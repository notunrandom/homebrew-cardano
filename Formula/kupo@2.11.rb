class KupoAT211 < Formula
  desc "Fast, lightweight & configurable chain-index for Cardano"
  homepage "https://github.com/CardanoSolutions/kupo"
  url "https://github.com/CardanoSolutions/kupo/archive/refs/tags/v2.11.tar.gz"
  sha256 "1b823b35c31b46ffce2794eea570dd6ace826b171a839d6d57d72780ec646a78"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/kupo@2.11-2.11"
    sha256 cellar: :any, arm64_tahoe:   "07b4d920b49707a1af00d690b486b273334c5784d8402c14cccbd3a08f159917"
    sha256 cellar: :any, arm64_sequoia: "c21750b49547f48972e371b22279a1ec8f45fee7b5893206d2f10c9c95be7a1f"
    sha256 cellar: :any, arm64_linux:   "fca1fa33ed5654d38b90ea232204c9b6ad5567f094da5ff5c78e5944ce18f4f9"
    sha256 cellar: :any, x86_64_linux:  "dad50759d0851a4613c9b76585dbbd0effbb59af9de2e6c94a8adc5c47ab5208"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "hpack" => :build
  depends_on "pandoc" => :build
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "pkg-config"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    secp256k1 = Formula["notunrandom/cardano/secp256k1@0.3.2"]
    ENV.prepend_path "PKG_CONFIG_PATH", secp256k1.opt_lib/"pkgconf"
    system "hpack"
    system "cabal", "update"
    system "cabal", "build", "exe:kupo"
    system "cabal", "v2-install", *std_cabal_v2_args, "exe:kupo"
    pandoc_args = [
      "--standalone",
      "--from=markdown",
      "--to=man",
      "--output=kupo.1",
    ]
    system "pandoc", *pandoc_args, "docs/man/README.md"
    man1.install "kupo.1"
  end

  test do
    system bin/"kupo", "--version"
    system "man", "kupo"
  end
end
