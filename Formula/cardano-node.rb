class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.1.tar.gz"
  sha256 "4c0dec126688deff14f7942a62e2224ddb12237d5150d210abff068e44bce61a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node-10.6.1"
    sha256 cellar: :any,                 arm64_tahoe:   "fb27d4764d2182a8ccaaad2ec41c0c502300d784cbe8e2491594c7e41665c7b8"
    sha256 cellar: :any,                 arm64_sequoia: "7949efe52f6115989bee65216f38591a50b76529edb9c3522d4f382493fe4f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fccc0500cd7069054c17d10248364d4cf4a239f78b4f7b04ac875f25d500ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dadfa7d54f1ac8103c56687887eba9184e4f8330abfeb2f6bc897bc69a39a471"
  end

  depends_on "ghcup" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "llvm"
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
