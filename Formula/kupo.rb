class Kupo < Formula
  desc "Fast, lightweight & configurable chain-index for Cardano"
  homepage "https://github.com/CardanoSolutions/kupo"
  url "https://github.com/CardanoSolutions/kupo/archive/refs/tags/v2.11.tar.gz"
  sha256 "1b823b35c31b46ffce2794eea570dd6ace826b171a839d6d57d72780ec646a78"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/kupo-2.11"
    sha256 cellar: :any,                 arm64_tahoe:   "84889e1486a1b18ad4fed1dcd4aadd07a50398b245e6b46bf91eed3511c92def"
    sha256 cellar: :any,                 arm64_sequoia: "43ecfdc0ee32a5e119743422bd9350b0202d7e444cc5da60eea99bb3c0a96887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9db9dd9faae000cd1b94163d3f7737ddb9a3066983c94992a283cb18f704acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5e2dd74835bf2a9339f6e284f11c8928cda01d62c2f83efa3213f930262a5d"
  end

  depends_on "ghcup" => :build
  depends_on "hpack" => :build
  depends_on "pkg-config" => :build
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"

  on_linux do
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
    system "hpack"
    system "cabal", "update"
    system "cabal", "build", "exe:kupo"
    system "cabal", "v2-install", *std_cabal_v2_args, "exe:kupo"
  end

  test do
    system bin/"kupo", "--version"
  end
end
