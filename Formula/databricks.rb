class Databricks < Formula
  desc "Databricks"
  version "0.200.2"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "918c50a5733bf94ca813f3e07ad3c663816c707dbfabedd0e67a3939217fcf09"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "02238db86ecb2527b0c36b7f792eb9d9c61675636b6c099b9cf31037cbb466bb"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "5f15a893928103316edc421e04cb052d06065c18ae91a9900d05963181c6d832"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "0f325bbd9b2f58968bde02cc79ea1513e077e678335b284c62d56eaa2b0749da"
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
