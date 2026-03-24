# Contributing

[Homebrew][brew] is a package manager for MacOS and Linux. It can greatly
improve the user experience of installing tools or libraries on those
platforms.

"Mainstream" packages can be added to the official Homebrew list of packages
(by submitting pull requests on the [Homebrew/Core][core] repository).

Packages that do not fit the requirements of Homebrew-core can be provided by
creating a ["tap"][taps], i.e. an additional and unofficial "Third-party"
source of Homebrew packages.

The Haskell cardano-node itself, and consequently many tools that use the same
dependencies, are not currently ["acceptable formulae"][acceptable] for
[Homebrew/Core][core] so for the time being, I have created a Third-party tap:

<https://github.com/notunrandom/homebrew-cardano>

N.B. The repository must have the `homebrew-` prefix in its name. But in `brew`
commands, one usually refers to this tap without the `homebrew-` prefix.

## Pre-requisites

- [Homebrew][brew] itself must be installed.
- You must have a GitHub account with SSH access configured
- Either:
  * you have write permissions on this repository (the following instructions
    assume this is the case);
  * or you must fork this repository (in which case you must adapt some of the
    following instructions accordingly).

## Preparations

To work on this tap it is first necessary to clone it into your local Homebrew
installation:

```bash
brew tap notunrandom/cardano git@github.com:notunrandom/homebrew-cardano.git
```

Then change into the directory where the clone is located:

```
pushd $(brew --repo notunrandom/cardano)
```

## Modifying/updating existing formulae

It is imperative:
- to submit changes to formulae as a PR
- to only include changes to a single formula in any given PR

Therefore, before making any changes, checkout a new branch, ideally with a
name indication which formula is being modified and why, e.g.:

```bash
git checkout -b cardano-node-bump
```

After making changes with your favourite editor (in this example, to
./Formula/cardano-node.rb), you can commit to the branch to save your progress.

When you are ready to try it out, you must first test your formula locally
using these three steps (continuing to use cardano-node as the example formula
being modified):

```
HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new cardano-node
```

This will analyse your formula code, it's like a linter. Fix all errors before
proceeding.

```
HOMEBREW_NO_INSTALL_FROM_API=1 brew install \
  --build-from-source --verbose --debug cardano-node
```

This will attempt to use your Formula to build, from source, a locally
installed version of the package. Again, fix all errors before proceeding. N.B.
Once the installation succeeded at least once, if you want to make changes, you
will need to replace `install` by `reinstall` in the above command. Note that
if this step succeeds the software is actually installed in your local homebrew
installation, so you can use it or test it further.

```
HOMEBREW_NO_INSTALL_FROM_API=1 brew test cardano-node
```

This will test the resulting installation (using the test defined in the
formula).

Once you are satisfied that your formula is working, you can commit your new
formula. Then push to the upstream branch:

```bash
git push -u origin cardano-node-bump
```

Important:

- you must work in a branch, and one formula at a time.
- you must push your branch to the upstream repo so that a pull request can be
  created. Do not push directly to main.
- you must use a pull request to submit your new or modified formula (only this
  way will the GitHub actions be usable)
- your pull request must only concern a single formula - use a separate branch
  and separate pull request for each formula you add or modify.

For the maintainers of the tap, the last stages are done in GitHub:

1. Create a pull request from the pushed branch.
2. Wait for the GitHub actions triggered by the pull request to complete.
3. If they are all green, add the "pr-pull" label to the PR - this will
   automatically merge and delete the branch, create the "bottles" and put them
   in "Releases", add the links to the "bottles" in the formula and close the
   PR.

## Adding formulae

For new formulae, it is also necessary to create a branch (e.g. named after the
new formula).

Then it is of course possible to copy and adapt one of the existing formulae.

But `brew` also provides facilities, for example to create an initial version
of your new formula.

Identify the URL of the repository for which you want to create a formula.
The URL must point to a .tar.gz (not a .zip) of the source code of a specific
branch, tag or commit. Look at the `url` field in existing formulae or follow
these examples:

- <https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.5.1.tar.gz>
  points to a version tag.
- <https://github.com/IntersectMBO/ouroboros-consensus/archive/refs/heads/release/ouroboros-consensus-0.28.0.0.tar.gz>
  points to a release/version branch
- <https://github.com/intersectMBO/libsodium/archive/dbb48cce5429cb6585c9034f002568964f1ce567.tar.gz>
  points to a commit - here brew will not be able to deduce a version so a
  `--set-version` flag will be needed.

Use `brew create --help` to see whether brew has a template for the kind of
code used in the repository (e.g. it has a `--cabal` option for Haskell and a
`--rust` option for Rust).

Use `brew create` to initialise your formula, specifying the tap, the template
and the URL.

Here is a first example, for Moog, which is a Haskell project built with Cabal,
and has version tags:

```bash
brew create --tap notunrandom/cardano --cabal \
  https://github.com/cardano-foundation/moog/archive/refs/tags/v0.4.1.1.tar.gz
```

Here is a second example, for Amaru, which is a Rust project which does not yet
have version tags or branches, so we will use the HEAD of main and manually
specify a low version:

```bash
brew create --tap notunrandom/cardano --rust --set-version 0.1.0.0 \
  https://github.com/pragma-org/amaru/archive/refs/heads/main.tar.gz
```

This will open an editor session of the generated Formula. You can keep the
session open to continue editing the Formula, or close it and open the file
later or with another editor.

From now on, as you work on the formula, you can commit (locally) to save your
progress.

To adapt the generated formula to the specifics of the project, get inspiration
from existing formula in the [notunrandom/cardano][tap], read the [Formula
Cookbook][formula] and/or get inspiration from exiting formulae in
[Homebrew/Core][core].

The audit/build/test/commit/push cycle is the same as described above when
modifying an existing formula.

## How the tap was initially created

Although new Formulae can now be added to the existing
[notunrandom/cardano tap][tap], the process of creating the tap is documented
here for posterity or future reference.

Create a completely empty GitHub repository for formulae, whose name must be
prefixed with "homebrew": e.g. notunrandom/homebrew-cardano

Then locally create a new tap, initialise git and push:

```
brew tap-new --no-git notunrandom/homebrew-cardano
pushd $(brew --repo notunrandom/cardano)
git init -b main
git config user.name "notunrandom"
git config user.email "122674938+notunrandom@users.noreply.github.com"
git add .github README.md
git commit -m"Genesis"
git remote add origin git@github.com:notunrandom/homebrew-cardano.git
git push -u origin main
```

Then from GitHub, add a license, then locally, pull, and create a branch:

```
git pull
```

This (with the `--no-git` option) is the most failsafe process, so that you can
control the git init process.


[brew]: https://brew.sh/
[taps]: https://docs.brew.sh/Taps
[core]: https://github.com/Homebrew/homebrew-core
[acceptable]: https://docs.brew.sh/Acceptable-Formulae
[tap]: https://github.com/notunrandom/homebrew-cardano
[formula]: https://docs.brew.sh/Formula-Cookbook

