class Ogmios < Formula
  desc "Lightweight JSON/RPC bridge interface for cardano-node"
  homepage "https://github.com/cardanosolutions/ogmios"
  url "https://github.com/cardanosolutions/ogmios.git"
  version "7.0.0"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/ogmios-7.0.0"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:  "8d59165694b40e090e26a5eff6365d0de288bd2c9349a61ebe6b45c26451db52"
    sha256 cellar: :any, arm64_linux:  "a4e089abc8674572b3886f177fe98b06ccf882bea6ec79e3f02d2f5e40e756e5"
    sha256 cellar: :any, x86_64_linux: "3effb4b134e7a3cc1c03b361b88fbacc58ed1174f2cdeaed20c8b60de830f1cf"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "notunrandom/cardano/blst"
  depends_on "notunrandom/cardano/cardano-node"
  depends_on "notunrandom/cardano/libsodium-cardano"
  depends_on "notunrandom/cardano/lmdb@0.9.36"
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

    lmdb = Formula["notunrandom/cardano/lmdb@0.9.36"]
    ENV.prepend_path "PKG_CONFIG_PATH", lmdb.opt_lib/"pkgconfig"

    cd = src/"server"
    Dir.chdir(cd) do
      system "cabal", "update"
      system "cabal", "build", "ogmios:exe:ogmios"
      system "cabal", "v2-install", *std_cabal_v2_args, "ogmios:exe:ogmios"
    end
    (etc/"cardano/ogmios/#{version}").mkpath
    (var/"cardano/ogmios").mkpath
    cardano_node_version = Formula["cardano-node"].version
    (libexec/"ogmios-service.sh").write <<~SH
      #!/bin/bash
      NETWORK=preprod
      NODESVCCONFIG="#{etc}/cardano/#{cardano_node_version}/cardano-node-service.conf"
      if [[ -f "$NODESVCCONFIG" ]]; then
        source "$NODESVCCONFIG"
      fi
      PORT=1337
      HOST=127.0.0.1
      SVCCONFIG="#{etc}/cardano/ogmios/#{version}/ogmios-service.conf"
      if [[ -f "$SVCCONFIG" ]]; then
        source "$SVCCONFIG"
      fi
      CONFIG="#{etc}/cardano/#{cardano_node_version}/$NETWORK/config.json"
      SOCKET="#{var}/cardano/#{cardano_node_version}/$NETWORK/node.socket"
      exec "#{bin}/ogmios" --host $HOST  --port $PORT --node-config $CONFIG --node-socket $SOCKET
    SH
    (libexec/"ogmios-service.sh").chmod 0755
  end

  service do
    run [opt_libexec/"ogmios-service.sh"]
    keep_alive true
    log_path var/"cardano/ogmios/log"
    error_log_path var/"cardano/ogmios/log"
  end

  test do
    system bin/"ogmios", "--version"
    assert_path_exists etc/"cardano/ogmios/#{version}"
    assert_path_exists var/"cardano/ogmios"
  end
end
