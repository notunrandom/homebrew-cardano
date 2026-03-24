class Kupo < Formula
  desc "Fast, lightweight & configurable chain-index for Cardano"
  homepage "https://github.com/CardanoSolutions/kupo"
  url "https://github.com/CardanoSolutions/kupo/archive/refs/tags/v2.11.tar.gz"
  sha256 "1b823b35c31b46ffce2794eea570dd6ace826b171a839d6d57d72780ec646a78"
  license "MPL-2.0"

  depends_on "ghcup" => :build
  depends_on "notunrandom/cardano/blst" => :build
  depends_on "notunrandom/cardano/libsodium-cardano" => :build
  depends_on "notunrandom/cardano/secp256k1@0.3.2" => :build
  depends_on "pkg-config" => :build

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
    system "cabal", "build", "kupo"
    system "cabal", "v2-install", *std_cabal_v2_args, "kupo"
  end

  test do
    system bin/"kupo", "--version"
  end
end
