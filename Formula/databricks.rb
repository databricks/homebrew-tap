class Databricks < Formula
  desc "Databricks"
  version "0.203.2"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "9bf111f29732d36a1871898d8ef2ce7d90a4cded8c53f8c037b0b137ac4b7705"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "63abe66a9d150d04c75f38a9a3660f3f1ace6ce7f419d07fa9d60a91b836bf72"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "788079dff619ac448d492dade28b049532638d00f77e1435cf9698a30222a542"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "225235335d11d4b822c5c504cd85286e2b73a209e1ca6cdfcf289535bc99ea34"
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
