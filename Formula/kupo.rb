class Kupo < Formula
  desc "Fast, lightweight & configurable chain-index for Cardano"
  homepage "https://github.com/CardanoSolutions/kupo"
  url "https://github.com/CardanoSolutions/kupo/archive/refs/tags/v2.11.tar.gz"
  sha256 "1b823b35c31b46ffce2794eea570dd6ace826b171a839d6d57d72780ec646a78"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/kupo-2.11"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9c4c0e1d7067bd65a596814bee23055f186858ca25260ad2b6659c1e74d1245e"
    sha256 cellar: :any,                 arm64_sequoia: "cce62204431b65f10b1ad075a6812750acb119bd9cd5c985be52b6cdd9a280b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76745124e08960966ae775165ad3d3fb5faeea5ab3f985dcfeb394ad22e9ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1634265cb61031c4abcd691364d78305c5693d7683eb08b49143df9109c8bcda"
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
