class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/11.0.1.tar.gz"
  sha256 "e920d38a6f4e2b23e591040530e515e770075f3cb4ce2e51e7eafcb1082bf7ae"
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
