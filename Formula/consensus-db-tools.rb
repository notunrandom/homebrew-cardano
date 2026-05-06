class ConsensusDbTools < Formula
  desc "Tools to inspect and manipulate the Cardano node's chainDB and ledger databases"
  homepage "https://github.com/IntersectMBO/ouroboros-consensus"
  url "https://github.com/IntersectMBO/ouroboros-consensus/archive/refs/tags/release-ouroboros-consensus-3.0.1.0.tar.gz"
  version "10.7.1"
  sha256 "7cb155508134f39684ba3cd330d9803b9a290f156ff6db0c399b99457b215874"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/consensus-db-tools-10.7.1"
    sha256 cellar: :any,                 arm64_tahoe:   "812a66aff23649edc2bd78e1b9c4bcb477e7d9622352b4b2c22b285bbd4c5b56"
    sha256 cellar: :any,                 arm64_sequoia: "406e4d138be275aec3d64a178e3012554685034f50f6c274e0e7a1f8a661b284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89400d61e05a41aaa577ab8f893204931d878ae0c561334696ad7bb86fbc507d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c66bf068b13bd19eea84cfad8f1f160540bc48cdeeaa6d5ca844d3c70401a016"
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
