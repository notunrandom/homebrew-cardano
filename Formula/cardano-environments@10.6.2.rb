class CardanoEnvironmentsAT1062 < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.6.2.tar.gz"
  sha256 "8f4732d34471e4c0b88f5e69becbaa767534e1bca7493f901bc2d7fe4ece5a0e"
  license "Apache-2.0"

  def install
    (prefix/"placeholder").write("")
    (etc/"cardano"/"10.6.2"/"mainnet").mkpath
    (etc/"cardano"/"10.6.2"/"preprod").mkpath
    (etc/"cardano"/"10.6.2"/"preview").mkpath
    (etc/"cardano"/"10.6.2"/"mainnet").install Dir["mainnet/*"]
    (etc/"cardano"/"10.6.2"/"preprod").install Dir["preprod/*"]
    (etc/"cardano"/"10.6.2"/"preview").install Dir["preview/*"]
  end

  def caveats
    <<~EOS
      Cardano environments have been installed to #{etc}/cardano/10.6.2.
      To use, e.g. for mainnet, pass this flag to cardano-node:
        --config $(brew --prefix)/etc/cardano/10.6.2/mainnet/config.json
    EOS
  end

  test do
    assert_path_exists etc/"cardano/10.6.2/mainnet/config.json"
    assert_path_exists etc/"cardano/10.6.2/preprod/config.json"
    assert_path_exists etc/"cardano/10.6.2/preview/config.json"
  end
end
