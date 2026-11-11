# homebrew-tap

Easily install the [Databricks CLI](https://github.com/databricks/cli) using [Homebrew](https://brew.sh/).

Full documentation about installation can be found at:
* (AWS) https://docs.databricks.com/en/dev-tools/cli/install.html
* (Azure) https://learn.microsoft.com/en-us/azure/databricks/dev-tools/cli/install
* (GCP) https://docs.gcp.databricks.com/en/dev-tools/cli/install.html

## Usage

Add the tap and trust it:

```bash
brew tap databricks/tap
brew trust databricks/tap
```

`brew trust databricks/tap` is required as of [Homebrew 6.0.0](https://docs.brew.sh/Tap-Trust),
which requires third-party taps to be trusted before Homebrew will load their
formulae. Existing users who tapped before upgrading to Homebrew 6.0.0 need to
run it once as well.

To install or upgrade the Databricks CLI, run:

```bash
brew install databricks
```

(You can also install in a single step without trusting the whole tap with
`brew install databricks/tap/databricks`.)

If this tap has been updated but you don't see it show up locally, you can force an update with:

```bash
brew update --force
```

## Installing an older version

If you need to install an older version of the Databricks CLI, you can do so with:

```bash
brew tap-new databricks/tap-old
brew extract --version=0.218.0 databricks/tap/databricks databricks/tap-old
brew trust databricks/tap-old
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

## Installing the latest development build

If you need the latest build of the [`main` branch](https://github.com/databricks/cli/tree/main),
you can install it with `--HEAD`. This downloads the artifact of the latest successful
[`release-build`](https://github.com/databricks/cli/actions/workflows/release-build.yml) run.

GitHub only serves workflow artifacts to authenticated users, so you need to be logged in with
[`gh auth login`](https://cli.github.com/manual/gh_auth_login) or set `HOMEBREW_GITHUB_API_TOKEN`.
Note that the artifact contains the builds for all platforms and is about 200 MB.

```bash
# Uninstall the stable version (if it's already installed)
brew uninstall databricks

brew install --HEAD databricks/tap/databricks
```

The installed version is labeled with the commit it was built from (e.g. `HEAD-002627a`).
A regular `brew upgrade` doesn't update it. To upgrade to the latest build, run:

```bash
brew upgrade --fetch-HEAD databricks
```

To revert back to the latest stable version, run:

```bash
brew uninstall databricks
brew install databricks/tap/databricks
```

## Shell completion

As long as you have configured shell completion for Homebrew itself,
shell completion for the Databricks CLI will work out of the box.

You can find documentation for setting this up at https://docs.brew.sh/Shell-Completion.
