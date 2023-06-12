class Databricks < Formula
  desc "Databricks"
  version "0.100.3"

  download_prefix = "https://databricks-bricks.s3.amazonaws.com"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "c3428e9fdb65c90fe2aeb91d7088d1c280151edbba91fca32e994192101401d9"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "66946e38b5133b540c671469d277ad5ccab5f05925e7c0be5d8e76d8d6757982"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "a748a21537ddd21547a73d845b1e1ca1e66c514f64b6324b75a31c9c8d39333c"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "7775c609218f237b5d125ba81c7982b7a71064b4e2cf77b7a5f362a3d33d8c72"
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
