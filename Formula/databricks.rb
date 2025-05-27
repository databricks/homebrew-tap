class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "0.253.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "8a1e9aa8318bea9c060ea8a09f79b2d301ebfbea00744f7bfc8648f4508ed574"
  darwin_arm64_sha = "5d95dd4301b3854153daf30e56d6a376ac564f93d923ade9dfd73f52703ed031"
  linux_amd64_sha = "ceaad6c0fb3ca10c7167c25a6e045999a56408852ee27fd1cddb5501a5d285ab"
  linux_arm64_sha = "c4a655fe04ab1b5ee8396f2134d04f229a3b4f4d8e8a17a00670fe8dc455773c"

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
