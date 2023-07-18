class Databricks < Formula
  desc "Databricks"
  version "0.201.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "04bed42589c0ec1fe4a79343e6b0e41a15c2c00c57d404e4c03a9477e8fd0d06"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "b44d7f520f9c902a64b8694d3caba7306fbad195763e6b59c88ffb85367f4788"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "2b6b0c88a2d8d84b4aa2fb7ac241e67e79767ce46ff4a96fb13a8fff313c5655"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "0aeb68dc4cce8df1cca86f456da9b3f57a637874892a3569a87e2d892d4813a7"
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
