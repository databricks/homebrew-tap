class Databricks < Formula
  desc "Command-line interface for the Databricks platform"
  homepage "https://github.com/databricks/cli"

  version "0.242.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "ab85549a5ed72df2a17d09f21b85bcb5a56fae3aa472ebc5b91fdb72667d503d"
  darwin_arm64_sha = "c154bdc2746291de25dce5e02cd41489929993f810e6d6c35cb236eb59f37611"
  linux_amd64_sha = "6d4c6a1ac2a36079b33e8dad6a41a400095f8da0dc79d26f53ce6c417d29bac1"
  linux_arm64_sha = "15b0c9619af92fed16f5e4a8adb7184834342beaba9a06928d5300358bc43f01"

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
