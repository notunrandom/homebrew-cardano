class ConsensusDbTools < Formula
  desc "Tools to inspect and manipulate the Cardano node's chainDB and ledger databases"
  homepage "https://github.com/IntersectMBO/ouroboros-consensus"
  url "https://github.com/IntersectMBO/ouroboros-consensus/archive/d3c4b5c029bde7b7233f6f7bbd21968b4f62b020.tar.gz"
  sha256 "53428c5e8c62807dbaf97a9f201b702de2dc942e8b81661482d0a3c5f8d69994"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/consensus-db-tools-020"
    sha256 cellar: :any,                 arm64_tahoe:   "0f773665f2508de9b409a22a307c10f639787fb57328bdcab2774406ef51ac9b"
    sha256 cellar: :any,                 arm64_sequoia: "25425237653a853531c24f3270309446df98855c97bc1f6bd488aabbb6a0a566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711c67e51c5a931c88b514a8ea478e18ee589a236ba9c600e1bf3c3483689f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4cb74ade1cd3c153a2946e242e78db0ffd297f04b45d2b93716d54726ba3b69"
  end

  depends_on "ghcup" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "zlib"

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
