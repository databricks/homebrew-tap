class Databricks < Formula
  desc "Databricks"

  # bump the version and change the sha256 every time we need something new
  version "0.100.0"

  download_prefix = "https://databricks-bricks.s3.amazonaws.com"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "27b00c9724bcfd966a138565a2d35a0407d9deb311f1a17c6d5edad504f4b2a6"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "391d34e80950942245fabf044d617800223b2c4ee82d409bb43b40bd8b96b329"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "4b15764b2646cae7b161ddec650ddee080b870cf470548c844260f1c41d8257b"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "edf153830055b8acdbdf514bc4a88c3aab65f97e0e5ca4c68fe60257fc205ab1"
  end

  def install
    bin.install "databricks"
    generate_completions_from_executable(bin/"databricks", "completion")
    ohai "Installation complete! Check if 🧱 🧱 🧱 completions do work."
    puts <<~EOS
    To ensure bricks <TAB> completion works in zsh, you can add the directory 
    $(brew --prefix)/share/zsh/site-functions to your $fpath. You can do this by 
    adding it to your ~/.zshrc file:

        echo fpath+=$(brew --prefix)/share/zsh/site-functions >> ~/.zshrc
    
    Most likely you'll also have to rebuild completion index:

        echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

    ... and open new terminal window.

    See https://docs.brew.sh/Shell-Completion
    EOS
  end

  test do
    system "#{bin}/databricks version"
  end
end
