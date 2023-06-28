class Databricks < Formula
  desc "Databricks"
  version "0.200.0"

  download_prefix = "https://github.com/databricks/cli/releases/download"
  arch_string = Hardware::CPU.intel? ? "amd64" : "arm64"
  darwin_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_darwin_#{arch_string}.zip"
  linux_url = "#{download_prefix}/v#{version}/databricks_cli_#{version}_linux_#{arch_string}.zip"

  if OS.mac? && Hardware::CPU.intel?
    url darwin_url
    sha256 "8a93a00e1043172600c72dcf86cf8dbfe7e441809f2ac5e5885c59ec526866a4"
  end

  if OS.mac? && Hardware::CPU.arm?
    url darwin_url
    sha256 "8f7dfdf3a701069d96ada19f2a0d7ccaced0d977f7a620e5b155c8ddb722d18e"
  end

  if OS.linux? && Hardware::CPU.intel?
    url linux_url
    sha256 "c02454355d011a16ab3a1c8a862e0f444e531a655fd76554f182e093ce99a113"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url linux_url
    sha256 "b06460526846bf3d87b42d40b9109b79e2d9eb6f2eaa579bb7d238ccd501316e"
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
