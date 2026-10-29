require "download_strategy"
require "utils/curl"
require "utils/github/api"

# Downloads the "cli" artifact of the latest successful release-build run on databricks/cli main.
# The formula's head URL is the GitHub API query for that run.
#
# release-build runs on every push to main, so the run's commit plays the role of the "last commit"
# of a repository. Homebrew only labels installs as HEAD-<commit> and only lets `brew upgrade --fetch-HEAD`
# detect newer builds for subclasses of VCSDownloadStrategy, hence the base class.
#
# GitHub only serves workflow artifacts to authenticated users, so this needs a GitHub token
# (HOMEBREW_GITHUB_API_TOKEN, `gh auth login`, or the macOS keychain).
class DatabricksCliArtifactDownloadStrategy < VCSDownloadStrategy
  # Only queries the API, so checking for a newer build doesn't download the artifact.
  def fetch_last_commit
    short_commit(latest_run.fetch("head_sha"))
  end

  def last_commit
    return fetch_last_commit if @latest_run || !commit_file.exist?

    short_commit(commit_file.read.strip)
  end

  def source_revision
    commit_file.read.strip if commit_file.exist?
  end

  def stage(&block)
    UnpackStrategy.detect(artifact_zip, prioritize_extension: true)
                  .extract_nestedly(basename:             artifact_zip.basename,
                                    prioritize_extension: true,
                                    verbose:              verbose? && !quiet?)
    chdir(&block) if block
  end

  private

  def cache_tag
    "release-build-artifact"
  end

  def repo_valid?
    artifact_zip.exist? && commit_file.exist?
  end

  def clone_repo(timeout: nil)
    download_latest_artifact
  end

  def update(timeout: nil)
    return if commit_file.read.strip == latest_run.fetch("head_sha")

    download_latest_artifact
  end

  def artifact_zip
    cached_location/"artifact.zip"
  end

  def commit_file
    cached_location/"commit"
  end

  def short_commit(sha)
    sha[0, 7]
  end

  def latest_run
    @latest_run ||= GitHub::API.open_rest(url)["workflow_runs"]&.first ||
                    odie("No successful release-build run found on main of databricks/cli")
  end

  def download_latest_artifact
    token = GitHub::API.credentials
    raise GitHub::API::MissingAuthenticationError if token.blank?

    run = latest_run
    artifact = GitHub::API.open_rest(run["artifacts_url"])["artifacts"]&.find do |a|
      a["name"] == "cli" && !a["expired"]
    end
    odie "Run #{run["html_url"]} has no unexpired \"cli\" artifact" if artifact.nil?

    ohai "Downloading build of databricks/cli@#{short_commit(run["head_sha"])} from #{run["html_url"]}"
    cached_location.mkpath
    temporary_path = cached_location/"artifact.zip.incomplete"
    # curl drops the Authorization header when following the redirect to the storage backend.
    Utils::Curl.curl_download(artifact["archive_download_url"], to:      temporary_path,
                                                                header:  "Authorization: token #{token}",
                                                                secrets: [token])
    temporary_path.rename(artifact_zip)
    commit_file.write(run["head_sha"])
  end
end

class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "1.23.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "cc368545f77bfed08512d1494a8ef001efc50bddd4a111b834f11540dc429d50"
  darwin_arm64_sha = "1d632228c749deecb5812e9ca35490b02382d47d5c05dc6e466dff747fd5248a"
  linux_amd64_sha = "1b95b717b3fa97d8f53c85953d6b94aea3ab9a0c035b38ca492875b13b5f5b3d"
  linux_arm64_sha = "5f29cab04f98d7f5da0fcf69ca7a912d22ec737fdb113633c0d91600d8d172c2"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 darwin_amd64_sha
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 darwin_arm64_sha
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 linux_amd64_sha
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 linux_arm64_sha
  end

  release_build_runs_url = "https://api.github.com/repos/databricks/cli/actions/workflows/release-build.yml/runs" \
                           "?branch=main&event=push&status=success&per_page=1"
  head release_build_runs_url, using: DatabricksCliArtifactDownloadStrategy

  def install
    if build.head?
      # The artifact contains the archives for all platforms; unpack the one for this machine.
      os_string = OS.mac? ? "darwin" : "linux"
      arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
      system "unzip", "-o", "databricks_cli_#{os_string}_#{arch_string}.zip"
    end
    bin.install "databricks"
    generate_completions_from_executable(bin/"databricks", "completion")
    ohai "Installation complete! Check if 🧱 🧱 🧱 completions do work."
    puts <<~EOS
      To ensure Databricks <TAB> completion works in zsh, you can add the directory
      $(brew --prefix)/share/zsh/site-functions to your $fpath. You can do this by
      adding it to your ~/.zshrc file:

          echo fpath+=$(brew --prefix)/share/zsh/site-functions >> ~/.zshrc

      Most likely you'll also have to rebuild the completion index:

          echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

      ... and open new terminal window.

      See https://docs.brew.sh/Shell-Completion
    EOS
  end

  test do
    # Snapshot builds report the next patch version with a dev suffix, e.g. v1.21.1-dev+002627a95.
    expected = version.head? ? /Databricks CLI v\d+\.\d+\.\d+-dev/ : "Databricks CLI v#{version}"
    assert_match expected, shell_output("#{bin}/databricks --version")
  end
end
