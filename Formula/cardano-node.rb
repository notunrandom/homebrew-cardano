class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.2.tar.gz"
  sha256 "a68e36f5d06ffb999c1e74135f3e97185cc17077b4e055bdaab20a7af56f144e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node-10.6.2"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "e18768a5a417c0e4a4ee7fee74ca17f6b370cebf46d7287a261ea0325e08a148"
    sha256 cellar: :any,                 arm64_sequoia: "20c8843852d325a3a9d7c1dbce79bf79a478019783d107fd3fcc23b782e46b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa679020d0cde7d237e876d2ad260469c63b9dd578a76ce54bafa653efc3a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96d2bb66eb70ca86d479525f38740c98bda6b5a04ccd93ae5e372faa863ea0e"
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
    depends_on "ncurses"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
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
