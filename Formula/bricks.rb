class Bricks < Formula
  desc "Bricks"

  # bump the version and change the sha256 every time we need something new
  version "0.0.31"

  download_prefix = "https://databricks-bricks.s3.amazonaws.com"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/bricks_#{version}_darwin_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "553769d4a1d256a584e990daefa1d598fc90ffc8dd4de8ad0637247a620b4c6e"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "661821ff8045b7d69ee753a9083f9610590c24dfae07023cf904ee9b5b0ee0fb"
  end

  def install
    bin.install "bricks"
    generate_completions_from_executable(bin/"bricks", "completion")
    ohai "Installation complete! Check if completions do work."
    puts <<~EOS
    To ensure bricks <TAB> completion works in zsh, you can add the directory 
    $(brew --prefix)/share/zsh/site-functions to your $fpath. You can do this by 
    adding it to your ~/.zshrc file:

        echo fpath+=$(brew --prefix)/share/zsh/site-functions >> ~/.zshrc
    
    Most likely you'll also have to rebuild completion index:

        echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

    EOS
  end

  test do
    system "#{bin}/bricks version"
  end
end