class Ogmios < Formula
  desc "Lightweight JSON/RPC bridge interface for cardano-node"
  homepage "https://github.com/cardanosolutions/ogmios"
  url "https://github.com/cardanosolutions/ogmios.git"
  version "7.0.0"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/ogmios-7.0.0"
    sha256 cellar: :any, arm64_tahoe:   "85e31b80ea0d23ef608614e9bacc4af4517beeaffa4faea5bf1b905c252aa62a"
    sha256 cellar: :any, arm64_sequoia: "81317b1d4a29a3494fa3bdc64b0a6c4fdb43bf296924c7b72c459d26a668cdf4"
    sha256 cellar: :any, arm64_linux:   "473f228f526904e322d75c89195e78b24f27b7b7f9a57f65a74081821fe97099"
    sha256 cellar: :any, x86_64_linux:  "14708e583eb34e31be7039584f811cba9ec9b4362ae49b997997a7cc8fab4448"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-node"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    src = buildpath/"ogmios"
    system "git",
      "clone",
      "--recurse-submodules",
      "https://github.com/cardanosolutions/ogmios.git",
      src
    system "git", "-C", src, "fetch", "--tags"
    system "git", "-C", src, "checkout", "v#{version}"
    system "git", "-C", src, "submodule", "update", "--init", "--recursive"

    secp256k1 = Formula["notunrandom/cardano/secp256k1@0.3.2"]
    ENV.prepend_path "PKG_CONFIG_PATH", secp256k1.opt_lib/"pkgconfig"

    cd = src/"server"
    Dir.chdir(cd) do
      system "cabal", "update"
      system "cabal", "build", "ogmios:exe:ogmios"
      system "cabal", "v2-install", *std_cabal_v2_args, "ogmios:exe:ogmios"
    end
  end

  test do
    system bin/"ogmios", "--version"
  end
end
