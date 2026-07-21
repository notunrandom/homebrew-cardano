class ConsensusDbToolsAT1071 < Formula
  desc "Tools to inspect and manipulate the Cardano node's chainDB and ledger databases"
  homepage "https://github.com/IntersectMBO/ouroboros-consensus"
  url "https://github.com/IntersectMBO/ouroboros-consensus/archive/refs/tags/release-ouroboros-consensus-3.0.1.0.tar.gz"
  version "10.7.1"
  sha256 "7cb155508134f39684ba3cd330d9803b9a290f156ff6db0c399b99457b215874"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/consensus-db-tools@10.7.1-10.7.1"
    sha256 cellar: :any,                 arm64_tahoe:   "8a493a3b73e425f2da87ed18df7153b7e9a8e252b1dfa83374eecd62ef4bf0c8"
    sha256 cellar: :any,                 arm64_sequoia: "06c7565f86b4a5c79268b1ea941e7fd40f914d83abb1bfb6410e41490a7cea42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c5477f904dc0d2c751ed49b53d828fa18f58e416fb575902db911e0cce3ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b316cd7f448783f768457db1fd218067f632af38b7fb2cdfc4c12a42c29f761"
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
    ENV.prepend_path "PKG_CONFIG_PATH", secp256k1.opt_lib/"pkgconf"
    File.write("cabal.project.local", "with-compiler: ghc-9.6.7")
    system "cabal", "update"
    system "cabal", "build", "exe:db-analyser"
    system "cabal", "v2-install", *std_cabal_v2_args, "exe:db-analyser"
  end

  test do
    system bin/"db-analyser", "--help"
  end
end
