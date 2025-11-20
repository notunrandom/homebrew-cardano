# Cardano Homebrew tap

This is a Homebrew tap to install the Cardano node (more tools coming soon).

[![Demo](https://img.youtube.com/vi/Yd2lQGLwqgI/0.jpg)](https://www.youtube.com/watch?v=Yd2lQGLwqgI)


## Prerequisites

You only need to have previously installed [Homebrew](https://brew.sh/), which supports MacOS and Linux.

*Precompiled binaries are provided for MacOS Tahoe on Silicon (ARM), and Ubuntu 22.04 on x86. On other platforms installation will require about 20 minutes because it entails compiling from source.*

## Installation

To install the Cardano node (10.5.1) and CLI:

```bash
brew install notunrandom/cardano/cardano-node
```

Alternatively, to install only the C libraries upon which the Haskell code of the node depends (e.g. because you are developing for Cardano):

```bash
brew tap notunrandom/cardano
brew install blst libsodium-cardano secp256k1@0.3.2

```

## Trying out the node and CLI

After installation you should see that the `cardano-node` and `cardano-cli` commands are available from Homebrew:

```bash
which cardano-node
which cardano-cli

```

You can check the version with `--version` or display help with `--help`.

To actually try the node and CLI:

- first create and change into a testnet directory
- download the configuration files for the preprod network
- start the node

```bash
mkdir -p testnet/db && cd testnet
curl -O -J "https://book.play.dev.cardano.org/environments/preprod/{config,db-sync-config,submit-api-config,topology,byron-genesis,shelley-genesis,alonzo-genesis,conway-genesis,peer-snapshot}.json"
cardano-node run --topology topology.json --config config.json --database-path db --socket-path node.socket --port 3001

```

You should see the output showing that the node is syncing.

In a separate terminal, use the CLI to query the tip of your node (you may need to `brew install watch` before running the following command):

```bash
CARDANO_NODE_SOCKET_PATH=testnet/node.socket watch cardano-cli query tip --testnet-magic 1
```

## See also

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

`cardano-node --help`, `cardano-cli --help` or check [Cardano Developer Portal](https://developers.cardano.org/docs/get-started/infrastructure/node/running-cardano/)

