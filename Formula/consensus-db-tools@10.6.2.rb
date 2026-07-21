class ConsensusDbToolsAT1062 < Formula
  desc "Tools to inspect and manipulate the Cardano node's chainDB and ledger databases"
  homepage "https://github.com/IntersectMBO/ouroboros-consensus"
  url "https://github.com/IntersectMBO/ouroboros-consensus/archive/025ab689811dbf05583f41107f47347e597ce68b.tar.gz"
  version "10.6.2"
  sha256 "6607d35149ff2cff961ab639fa38de06a9de49994a0a8a17a7f42e5e6392cbba"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/consensus-db-tools@10.6.2-10.6.2"
    sha256 cellar: :any,                 arm64_tahoe:   "f91ef3ee744daf7cbb5dae064945bf0c26e684d342695eac22c90c211ef57593"
    sha256 cellar: :any,                 arm64_sequoia: "37da193f296bb6673974459447389c3ed4f132bd05b369617309ba38ced9d57c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5817cb5075142579bcdb1d5220b733bc91306edf59461fd0f0e2bded78fbcc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9598821e0c628e09efb53215b4e54cbc650b12f27411f4ef6cf41e403bc647ff"
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
    ENV.prepend_path "PKG_CONFIG_PATH", secp256k1.opt_lib/"pkgconf"
    File.write("cabal.project.local", "with-compiler: ghc-9.6.7")
    system "cabal", "update"
    system "cabal", "build", "exe:db-analyser"
    system "cabal", "v2-install", *std_cabal_v2_args, "exe:db-analyser"
  end

  test do
    system bin/"db-analyser", "--help"
  end
end
