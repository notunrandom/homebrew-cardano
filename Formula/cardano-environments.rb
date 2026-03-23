class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.6.2.tar.gz"
  sha256 "8f4732d34471e4c0b88f5e69becbaa767534e1bca7493f901bc2d7fe4ece5a0e"
  license "Apache-2.0"

  def install
    (prefix/"placeholder").write("")
    (etc/"cardano"/"mainnet").mkpath
    (etc/"cardano"/"preprod").mkpath
    (etc/"cardano"/"preview").mkpath
    (etc/"cardano"/"mainnet").install Dir["mainnet/*"]
    (etc/"cardano"/"preprod").install Dir["preprod/*"]
    (etc/"cardano"/"preview").install Dir["preview/*"]
  end

  def caveats
    <<~EOS
      Cardano environments have been installed to #{etc}/cardano.
      To use, e.g. for mainnet, pass this flag to cardano-node:
        --config $(brew --prefix)/etc/cardano/mainnet/config.json
    EOS
  end

  test do
    assert_path_exists etc/"cardano/mainnet/config.json"
    assert_path_exists etc/"cardano/preprod/config.json"
    assert_path_exists etc/"cardano/preview/config.json"
  end
end
