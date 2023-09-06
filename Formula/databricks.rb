class Databricks < Formula
  desc "Databricks"
  version "0.204.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "830b28092e06baabe6f5284c8f0799dc4f670ef0257e8ba1205b249ea8e91d2c"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "99c623723599631a75d5004df29068c9347185e20c3e852ec9e2a5848ccfed77"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "72a4044afd44c573dec7ae101dd6b914444a76741160e58511410d7f0b5cd153"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "3edbbdfa5135e7f17f5412708f01b4a103efd95b82eeb5bc4db7d8a76f579692"
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
