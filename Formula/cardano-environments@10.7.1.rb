class CardanoEnvironmentsAT1071 < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.7.1.tar.gz"
  sha256 "c323f43db37de9a85d9991bb52b8c9ee6a58549644d95a6f062269fde49e566c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-environments@10.7.1-10.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "580f06063c5e03c4b4daf99743c26378aaabce06f874316c6bd4a078bd09f698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894a15dad591444be8a209a5ac43d3208095b077ecc387a4677aad9148e3f4f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e8c6a09a0210921a53597987cf33a89d58dab9e1a350800062b32cc01d5bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56b7d6ea0ecb6db569712e1358ddfaf5712f583016b5abc9bfbece59d42ad596"
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
