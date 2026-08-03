class Ogmios < Formula
  desc "Lightweight JSON/RPC bridge interface for cardano-node"
  homepage "https://github.com/cardanosolutions/ogmios"
  url "https://github.com/cardanosolutions/ogmios.git"
  version "7.0.0"
  license "MPL-2.0"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-node"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "pkgconf"

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
