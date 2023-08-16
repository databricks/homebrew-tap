class Databricks < Formula
  desc "Databricks"
  version "0.203.1"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "3ed605ea363af947ac9007a91ef4cc6c225164c7719f3109eeb490477ac0a763"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "8416be18cb0f49dce1d26f28b13e30d8ddcca193ebd11f2bc7707775116def01"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "1fd7884a4de28f30494f10b60d3c07c64e420753017a48d3961084667db30e26"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "9cd5b08b8d81dab23a2d540ffd7dfd28c6b577b168cffb80347fa30de9dd2e47"
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
