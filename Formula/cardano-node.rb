class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.1.tar.gz"
  sha256 "4c0dec126688deff14f7942a62e2224ddb12237d5150d210abff068e44bce61a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node-10.6.1"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "29ee89e5f002e1e7a663fd71fca52a8e41abc428e520a5f0c0c0a5cb1b443273"
    sha256 cellar: :any,                 arm64_sequoia: "bcfef1c219a44a0d66d71d01b532c7b903f64ef2e48a3561482363387a15ae5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce9fc896b90c4165737385b4b8933f772b754a09fe753af68c0f5df0712a6fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6648aa48b5fc1a5b1d1ae5d663aee6e55c02cbe1e4349f04641db0c3a336c2"
  end

  depends_on "ghcup" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "openssl"

  on_linux do
    depends_on "systemd"
  end

  def install
    ENV["GHCUP_INSTALL_BASE_PREFIX"] = buildpath
    system "ghcup", "install", "ghc", "9.6.7"
    system "ghcup", "install", "cabal", "3.12.1.0"
    ENV.prepend_path "PATH", buildpath/".ghcup/bin"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["notunrandom/cardano/secp256k1@0.3.2"].opt_lib/"pkgconf"
    File.write("cabal.project.local", "with-compiler: ghc-9.6.7")
    system "cabal", "update"
    system "cabal", "build", "cardano-node"
    system "cabal", "build", "cardano-cli"
    system "cabal", "v2-install", *std_cabal_v2_args, "cardano-node"
    system "cabal", "v2-install", *std_cabal_v2_args, "cardano-cli"
  end

  test do
    system bin/"cardano-node", "--version"
  end
end
