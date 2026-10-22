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

  version "1.22.1"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "e7ff603287d3b9ff8fb92c1708fb9f3a85a715b867d5f2e9d6ec0403f5b597b4"
  darwin_arm64_sha = "71e85fd732bc374e12686531c0e4e74695b899b9c099b03d9f94d76dd0b78ea3"
  linux_amd64_sha = "2f24260441f211e75df4266fba506983cd2373c622cb34437d752befba8261af"
  linux_arm64_sha = "298a9ba90a941820072d58a9a4e56b957884d33523cc6aacc1c4b34c189b96a1"

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
