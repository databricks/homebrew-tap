class Databricks < Formula
  desc "Databricks"
  version "0.208.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  darwin_amd64_sha = "2ac5a4ef4e83c8e8bfeef68e618f34202cad472a06a6459ab01293cbdca4eee8"
  darwin_arm64_sha = "772a46f15f3c41e2522e1a91936a3efad13f313476aeddb61975bb04827ec29b"
  linux_amd64_sha = "cb8bd3d9a833bb09ac089f19ca32987538f803a60b98b88c36bc1dad45159b62"
  linux_arm64_sha = "ab4c7bd639dd37ce2068f6cfd2b99c8211e45424124c9ec6a0b7413cd90a6a9b"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 darwin_amd64_sha
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 darwin_arm64_sha
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 linux_amd64_sha
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 linux_arm64_sha
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
