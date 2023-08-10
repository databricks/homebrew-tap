class Databricks < Formula
  desc "Databricks"
  version "0.203.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "ec44e967189c971408daccf126e63b4a946b11a3d1393fa580874f4db9f6dc8b"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "1e97f49da77af08a2ab44443d1362215239307d825839b0035357ff618f6e9f0"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "2672ec244df6acea14c897740affa63811bcc9350829a16e9401456af15c86e0"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "4c37b279b8569276d6e0fb78923b4d230c9f70d8f92c8ca224717e4a04b5ac69"
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
