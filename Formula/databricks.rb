class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "0.228.1"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "c9e6744a1bfd5c75b30366de4c7570bdc9e71ebf044ab2e8c7a0a6cf079c002f"
  darwin_arm64_sha = "573469607f1434f7466681edd8cf06e6a96c630bfe81620fa7e64be98c70d444"
  linux_amd64_sha = "e7fb24f5cea8885c01c8c4cd21d91f24ffe44e14c8720a13952eba33eee59b10"
  linux_arm64_sha = "f9acf7a19ad39818769e97aacc4d8a32ebe96a60293f840588d1930835be5aef"

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
