class Databricks < Formula
  desc "Databricks"
  version "0.203.3"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "4fe9375536054ae3178a942f1fa895bba1689700a80ede6dd68fc1d917e478f2"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "3605aa65c4e6e6c2739ae04ae23a50de18436cbf23b7f0b97b2f622ad5583615"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "a11ac09a2aad3be84bed97bdc730e2d20787e1e4af4f00fdc16305cc4f638b8e"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "607fa6a011a0c574daf8886e3025ff4571d0da365e34b98307cc0047f5ed3b4d"
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
