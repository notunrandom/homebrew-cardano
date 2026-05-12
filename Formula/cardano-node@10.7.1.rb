class CardanoNodeAT1071 < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.7.1.tar.gz"
  sha256 "57749818645c0b2efe7e5ac1a97078452dc2ebd7620d75c30accf8737f247ce3"
  license "Apache-2.0"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-environments@10.7.1"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "openssl"
  depends_on "pkgconf"
  depends_on "protobuf"
  depends_on "snappy"

  on_linux do
    depends_on "liburing"
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
      (var/"cardano/#{version}/#{network}/db").mkpath
    end
    (libexec/"cardano-node-service.sh").write <<~SH
      #!/bin/bash
      NETWORK=preprod
      PORT=3001
      SVCCONFIG="#{etc}/cardano/#{version}/cardano-node-service.conf"
      if [[ -f "$SVCCONFIG" ]]; then
        source "$SVCCONFIG"
      fi
      CONFIG="#{etc}/cardano/#{version}/$NETWORK/config.json"
      TOPOLOGY="#{etc}/cardano/#{version}/$NETWORK/topology.json"
      DB="#{var}/cardano/#{version}/$NETWORK/db"
      SOCKET="#{var}/cardano/#{version}/$NETWORK/node.socket"
      exec "#{bin}/cardano-node" run --config $CONFIG --topology $TOPOLOGY --database-path $DB --socket-path $SOCKET --port $PORT
    SH
    (libexec/"cardano-node-service.sh").chmod 0755
  end

  service do
    run [opt_libexec/"cardano-node-service.sh"]
    keep_alive true
    log_path var/"cardano/log"
    error_log_path var/"cardano/log"
  end

  def caveats
    <<~EOS
      By default the service will run a preprod node.
      To change this or other parameters see:
      https://github.com/notunrandom/homebrew-cardano
    EOS
  end

  test do
    system bin/"cardano-node", "--version"
    system bin/"cardano-cli", "--version"
    assert_path_exists var/"cardano/#{version}/preview/db"
    assert_path_exists var/"cardano/#{version}/preprod/db"
    assert_path_exists var/"cardano/#{version}/mainnet/db"
    assert_path_exists etc/"cardano/#{version}/preview/config.json"
    assert_path_exists etc/"cardano/#{version}/preprod/config.json"
    assert_path_exists etc/"cardano/#{version}/mainnet/config.json"
    system "brew", "services", "info", "notunrandom/cardano/cardano-node"
  end
end
