class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.2.tar.gz"
  sha256 "a68e36f5d06ffb999c1e74135f3e97185cc17077b4e055bdaab20a7af56f144e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node-10.6.2"
    sha256 cellar: :any, arm64_tahoe:   "7b188144084342b3c16d46331e90e527431c1d5d194e785817a6d4372388befb"
    sha256 cellar: :any, arm64_sequoia: "0c0b268d4e25b0efb49295e02f94e6d19db944d1e47e85a16ffce4ad017c70e9"
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
