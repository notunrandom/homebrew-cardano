class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.7.1.tar.gz"
  sha256 "c323f43db37de9a85d9991bb52b8c9ee6a58549644d95a6f062269fde49e566c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-environments-10.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f9cb8f7876858a45356bea13b6e3932c610e6f76c41f683d059f76dd0e0059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c582988cc2661eac5fc73a3ee2c68012462bd1903ba32982fbde5c8ed284cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a00328727641dd85d8f0cf7d27a4e8e2840c5aae0ab14f12903272f459bac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d64f8202b391e8b673ee02c345b98323ba1b259bba372330c238176449fe05b"
  end

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
