class CardanoNode < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.2.tar.gz"
  sha256 "a68e36f5d06ffb999c1e74135f3e97185cc17077b4e055bdaab20a7af56f144e"
  license "Apache-2.0"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-environments"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "openssl"
  depends_on "pkgconf"

  on_linux do
    depends_on "ncurses"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["notunrandom/cardano/secp256k1@0.3.2"].opt_lib/"pkgconf"
    system "cabal", "update"
    %w[cardano-node cardano-cli].each do |tool|
      system "cabal", "build", tool
      system "cabal", "v2-install", *std_cabal_v2_args, tool
    end
    %w[mainnet preprod preview].each do |network|
      (var/"cardano"/network/"db").mkpath
    end
    symlink_etc = etc/"cardano"/"network"
    ln_s etc/"cardano"/"mainnet", symlink_etc unless File.exist?(symlink_etc)
    symlink_var = var/"cardano"/"network"
    ln_s var/"cardano"/"mainnet", symlink_var unless File.exist?(symlink_var)
  end

  service do
    run [
      HOMEBREW_PREFIX/"opt"/"cardano-node"/"bin"/"cardano-node",
      "run",
      "--config", etc/"cardano"/"network"/"config.json",
      "--topology", etc/"cardano"/"network"/"topology.json",
      "--database-path", var/"cardano"/"network"/"db",
      "--socket-path", var/"cardano"/"network"/"node.socket",
      "--port", "3001"
    ]
    keep_alive true
    log_path var/"cardano"/"network"/"log"
    error_log_path var/"cardano"/"network"/"log"
  end

  test do
    system bin/"cardano-node", "--version"
    assert_path_exists var/"cardano"/"preprod"/"db"
    assert_path_exists var/"cardano"/"network"
    assert_path_exists etc/"cardano"/"network"
    system "brew", "services", "info", "notunrandom/cardano/cardano-node"
  end
end
