# Cardano Homebrew tap

This is a Homebrew tap to install the Cardano node, and some associated tools.

## Prerequisites

You only need to have previously installed [Homebrew](https://brew.sh/), which
supports MacOS and Linux.

*Precompiled binaries are provided for MacOS Tahoe and Sequoia on Silicon
(ARM), Ubuntu 22.04 on x86 and Ubuntu 24.04 on ARM. On some other platforms
installation may require about 20 minutes if it entails compiling from source.*

## Installation

### Cardano-node preprod service

This formula installs an all-in-one non-block-producing cardano node (10.6.2)
that runs as a system service. The Cardano environments and cardano CLI are
also included.

```bash
brew install notunrandom/cardano/cardano-preprod-nbp
```

To start the service:

```bash
brew services start notunrandom/cardano/cardano-preprod-nbp
```

The Cardano-node is now running as a (user) daemon, and will automatically
re-start every time you log back in.

You can use the Cardano CLI to interact with it. First set an environment
variable which points to the running node's socket:

```bash
export CARDANO_NODE_SOCKET_PATH=$(brew --prefix)/var/cardano/preprod/node.socket
```

Then use any CLI commands, e.g.:

```bash
cardano-cli query tip --testnet-magic 1
```

If needed you can look at its log file, e.g.:

```bash
tail -f $(brew --prefix)/var/cardano/preprod/log
```

###

There is also a formula for
[Kupo](https://github.com/CardanoSolutions/kupo):

```bash
brew install notunrandom/cardano/kupo
```

### Cardano-node

If you need do not need the Cardano environments or system service, it is
sufficient to install the cardano-node by itself using this formula:

```bash
brew install notunrandom/cardano/cardano-node
```

This only installs the cardano-node and cardano-cli software, without any
environments (configurations), and without the service files.

### Cardano environments

The official "Cardano Environments" (configuration files) for the 10.6.2 node
can be installed thus:

```
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
