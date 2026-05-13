class ConsensusDbTools < Formula
  desc "Tools to inspect and manipulate the Cardano node's chainDB and ledger databases"
  homepage "https://github.com/IntersectMBO/ouroboros-consensus"
  url "https://github.com/IntersectMBO/ouroboros-consensus/archive/refs/tags/release-ouroboros-consensus-3.0.1.0.tar.gz"
  version "11.0.1"
  sha256 "7cb155508134f39684ba3cd330d9803b9a290f156ff6db0c399b99457b215874"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/consensus-db-tools-11.0.1"
    sha256 cellar: :any,                 arm64_tahoe:   "bfa0b20072860ca94cb8623af4c57431bc8e9d4a44085b998a2d6bd77b73a4ab"
    sha256 cellar: :any,                 arm64_sequoia: "c384f09b08ea1b7f77ab05165cee9f8d4c7e9f3d8a3e19f58219f3544318254d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58bb2d4a0ba4cbc29c65a3e79009bd691c2ac9c67afbb9181ad8640a773b07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db526417fbd9cfa266e9b9474879f02778d53ec7dc37b73a89cd3449b1430dfb"
  end

  depends_on "ghcup" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "zlib"

  on_linux do
    depends_on "liburing"
  end

  def install
    ENV["GHCUP_INSTALL_BASE_PREFIX"] = buildpath
    system "ghcup", "install", "ghc", "9.6.7"
    system "ghcup", "install", "cabal", "3.12.1.0"
    ENV.prepend_path "PATH", buildpath/".ghcup/bin"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["notunrandom/cardano/secp256k1@0.3.2"].opt_lib/"pkgconf"
    File.write("cabal.project.local", "with-compiler: ghc-9.6.7")
    system "cabal", "update"
    system "cabal", "build", "exe:db-analyser"
    system "cabal", "v2-install", *std_cabal_v2_args, "exe:db-analyser"
  end

  test do
    system bin/"db-analyser", "--help"
  end
end
