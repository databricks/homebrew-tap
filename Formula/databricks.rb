class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "0.283.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "9a2a3bd2db749f837475aee0eef5a398d9b54ff80febc335d6bb8b863f39f8df"
  darwin_arm64_sha = "592129ab416b0319e012952a95030f1b1e38020ad2082e6ac72b87489f2ca5bb"
  linux_amd64_sha = "39fcbfa3fd6545182b0b0f71d77bcdd353ae469664b9830904a26a43b640075b"
  linux_arm64_sha = "c3c344d3eb1aea34130f53c7f501642fb35d284d90a9ba885ec03db1839d7d71"

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

  def install
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
    assert_match "Databricks CLI v#{version}", shell_output("#{bin}/databricks --version")
  end
end
