class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "0.297.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "1f6fd67535508fb2559bac96d5824b2ade0997fe2e5f3c4d2774e22d28d0dcae"
  darwin_arm64_sha = "4f6ce85c5b30e0dec89acb3289a20ebf1dbfcb3dd277d7d066a851221cc71193"
  linux_amd64_sha = "4e5e4d9b8a33e667c948e5d66be3cf9b9c99740d119d34504b8a443f706cc8df"
  linux_arm64_sha = "a7da8a3848803c6b11437decd30ff4f8f37625d935d44690af6d58a336cda829"

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
