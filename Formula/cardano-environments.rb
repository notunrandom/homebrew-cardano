class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/11.1.3.tar.gz"
  sha256 "021cb30c1d1cfeb9e50293c0af6a7108a0bc125ffa7db061cc76cd732993922d"
  license "Apache-2.0"

  def install
    (prefix/"placeholder").write("")
    (etc/"cardano/#{version}/mainnet").mkpath
    (etc/"cardano/#{version}/preprod").mkpath
    (etc/"cardano/#{version}/preview").mkpath
    (etc/"cardano/#{version}/mainnet").install Dir["mainnet/*"]
    (etc/"cardano/#{version}/preprod").install Dir["preprod/*"]
    (etc/"cardano/#{version}/preview").install Dir["preview/*"]
  end

  def caveats
    <<~EOS
      Cardano environments have been installed to #{etc}/cardano/#{version}.
      To use, e.g. for mainnet, pass this flag to cardano-node:
        --config $(brew --prefix)/etc/cardano/#{version}/mainnet/config.json
    EOS
  end

  test do
    assert_path_exists etc/"cardano/#{version}/mainnet/config.json"
    assert_path_exists etc/"cardano/#{version}/preprod/config.json"
    assert_path_exists etc/"cardano/#{version}/preview/config.json"
  end
end
