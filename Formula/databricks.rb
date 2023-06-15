class Databricks < Formula
  desc "Databricks"
  version "0.100.4"

  download_prefix = "https://databricks-bricks.s3.amazonaws.com"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "dabe21f8cbd37d1593d0325613806c396082e737235a197f03de3185632aab47"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "115064ab1f04dfe707803d8e75e505862c8d2c666ed8626c83163ce423416377"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "e6a39b7a54de1b228ba3dc70ce35c21189828b32e8e333583548a2a3799aa809"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "73aa8fe6e2158977847383b9a643a61e2b7c24579aafd3f033185f1403598892"
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
