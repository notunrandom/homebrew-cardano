class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.5.1.tar.gz"
  sha256 "aa2ada4ca099b512790545539c98960349b9dda67559d19d1ba9eeef6333e27b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node-10.5.1"
    sha256 cellar: :any,                 arm64_tahoe:  "7290df3919a614670e5a28f225ced6ee76d08076f4b98c936fab5c4049924a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70a19799992d03237e96f973826ac9810821c5151c91c1014843caae1255e934"
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
