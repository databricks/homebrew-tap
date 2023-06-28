class Databricks < Formula
  desc "Databricks"
  version "0.200.1"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "ff55f39b32a6e508c775cdfbf7e2f077c8a89ba02933ae4934e60e7b8afd7d57"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "6001f89cef37f74ef659fd05cbbf0317dd83ae598ca5038eee6556102aaffb0e"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "520f8a83f763cd2e49aa5a6fffbefe81979a6a6674f8ad9d65dc056e34b1a2f2"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "f8bedca764db8ebd98757d38b3474fc45c2abd868295f7c441c4350facb3a061"
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
