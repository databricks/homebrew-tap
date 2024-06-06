# homebrew-tap

Easily install the [Databricks CLI](https://github.com/databricks/cli) using [Homebrew](https://brew.sh/).

## Usage

Initialize tap:

```bash
brew tap databricks/tap
```

To install or upgrade the Databricks CLI, run:

```bash
brew install databricks
```

If this tap has been updated but you don't see it show up locally, you can force an update with:

```bash
brew update --force
```

## Installing an older version

If you need to install an older version of the Databricks CLI, you can do so with:

```bash
brew tap-new databricks/tap-old
brew extract --version=0.218.0 databricks/tap/databricks databricks/tap-old
brew install databricks@0.218.0

# Unlink the latest version (if it's already installed)
brew unlink databricks

# Link the older version
brew link databricks@0.218.0
```

To revert back to the latest version, you can unlink the older version and link the latest version:

```bash
# Unlink the older version
brew unlink databricks@0.218.0

# Link the latest version
brew link databricks
```

You can clean up older versions with:

```bash
# Display all installed versions
brew list --versions databricks

# Uninstall an older version
brew uninstall databricks@0.218.0
```

You can clean up the tap with older versions with:

```bash
brew untap databricks/tap-old
```

## Shell completion

As long as you have configured shell completion for Homebrew itself,
shell completion for the Databricks CLI will work out of the box.

You can find documentation for setting this up at https://docs.brew.sh/Shell-Completion.
