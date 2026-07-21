class CardanoNodeAT1062 < Formula
  desc "Core component needed to participate in a Cardano decentralised blockchain"
  homepage "https://github.com/IntersectMBO/cardano-node"
  url "https://github.com/IntersectMBO/cardano-node/archive/refs/tags/10.6.2.tar.gz"
  sha256 "a68e36f5d06ffb999c1e74135f3e97185cc17077b4e055bdaab20a7af56f144e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-node@10.6.2-10.6.2"
    sha256 cellar: :any,                 arm64_tahoe:   "dc675f65feaeedde40d2a2cdc999305f0151017e3261bf2ec70ac96739872ac3"
    sha256 cellar: :any,                 arm64_sequoia: "023bb7b7341123931064e5caefcec489dad70a06701d38f3339d7da6bc706646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545a224bf681e7586c5b1151a8834cbd5e7c39f612b5b3579ab3aecab8f6c701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68031492ac183393e7478620a23b3d0ac116ee658328cdc8e9466b4b39d94f1b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "gmp"
  depends_on "lmdb"
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-environments@10.6.2"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/secp256k1@0.3.2"
  depends_on "openssl"
  depends_on "pkgconf"

  on_linux do
    depends_on "ncurses"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  version = "10.6.2"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("notunrandom/cardano/secp256k1@0.3.2")/"pkgconf"
    system "cabal", "update"
    %w[cardano-node cardano-cli].each do |tool|
      system "cabal", "build", tool
      system "cabal", "v2-install", *std_cabal_v2_args, tool
    end
    %w[mainnet preprod preview].each do |network|
      (var/"cardano"/version/network/"db").mkpath
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
    log_path var/"cardano"/version/"log"
    error_log_path var/"cardano"/version/"log"
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
    assert_path_exists var/"cardano"/version/"preview"/"db"
    assert_path_exists var/"cardano"/version/"preprod"/"db"
    assert_path_exists var/"cardano"/version/"mainnet"/"db"
    system "brew", "services", "info", "notunrandom/cardano/cardano-node"
  end
end
