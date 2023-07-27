class Databricks < Formula
  desc "Databricks"
  version "0.202.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "b573b6c1a81985bb3ba7bd44a709af1288a63bdab715bb1f24b1fed1689c13ee"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "3d8ff66995a66cfbc7124564a60654197f264b4333065f7407f4c078431a1aed"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "9f6d732616dfe1fa022d54dc2b39b718d576c21adb931aff7f207c9b26826494"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "55bf95d5ea2a69431ea8714109ff524c8cd98dd2520ea1a3139680444f727d33"
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
