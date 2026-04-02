# Cardano Homebrew tap

This is a Homebrew tap to install the Cardano node, and some associated tools.

## Prerequisites

You only need to have previously installed [Homebrew](https://brew.sh/), which
supports MacOS and Linux.

*Precompiled binaries are provided for MacOS Tahoe and Sequoia on Silicon
(ARM), Ubuntu 22.04 on x86 and Ubuntu 24.04 on ARM. On some other platforms
installation may require about 20 minutes if it entails compiling from source.*

## Installation

### Cardano-node

This formula installs:

- the Cardano Haskell node (10.6.2)
- the Cardano CLI
- the Cardano environments (configuration files)
- a launchd/systemd service to run cardano-node as a daemon

To install:

```bash
brew install notunrandom/cardano/cardano-node
```

To start the service:

```bash
brew services start notunrandom/cardano/cardano-node
```

With these two commands a mainnet, non-block-producing node is now running
as a (user) daemon, and will automatically re-start every time you log back
in.

To run a preprod node rather than mainnet, stop the mainnet service if
it has been started:

```bash
brew services stop notunrandom/cardano/cardano-node
```

Then modify two symbolic links:

```bash
cd $(brew --prefix)/etc/cardano
rm network
ln -s preprod network
cd $(brew --prefix)/var/cardano
rm network
ln -s preprod network

```

Then start the service as above.

To interact with the preprod node using the Cardano CLI, first set an
environment variable which points to the running node's socket:

```bash
export CARDANO_NODE_SOCKET_PATH=$(brew --prefix)/var/cardano/preprod/node.socket
```

Then use any CLI commands, e.g.:

```bash
cardano-cli query tip --testnet-magic 1
```

To look at its log file:

```bash
tail -f $(brew --prefix)/var/cardano/preprod/log
```

For more control, use the `cardano-node` command directly without starting
the service.

### Kupo

There is also a formula for
[Kupo](https://github.com/CardanoSolutions/kupo):

```bash
brew install notunrandom/cardano/kupo
```

### Cardano environments

The official "Cardano Environments" (configuration files) for the 10.6.2 node
can be installed separately (N.B.) they are included with the cardano-node
formula):

```bash
brew install notunrandom/cardano/cardano-environments
```

You fill find the files here:

```bash
ls -R $(brew --prefix)/etc/cardano
```

### Chain and Ledger DB tools

To install these tools to analyse, manipulate or generate chain and ledger DB's
(for a 10.6.2 node):

* `db-analyser`
* `snapshot-converter`
* `db-synthesizer`
* `db-truncater`
* `db-immutaliser`
* `immdb-server`

```bash
brew install notunrandom/cardano/consensus-db-tools
```

### Libraries

To install only the C libraries upon which the Haskell code of the node depends
(e.g. because you are developing for Cardano):

```bash
brew install notunrandom/cardano/{blst,libsodium-cardano,secp256k1@0.3.2}
```

## See also

`cardano-node --help`, `cardano-cli --help` or check [Cardano Developer
Portal](https://developers.cardano.org)

How to [contribute](./CONTRIBUTING.md) to this tap.

`brew help`, `man brew` or check [Homebrew's
documentation](https://docs.brew.sh).
