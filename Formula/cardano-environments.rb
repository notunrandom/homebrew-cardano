class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.6.2.tar.gz"
  sha256 "8f4732d34471e4c0b88f5e69becbaa767534e1bca7493f901bc2d7fe4ece5a0e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-environments-10.6.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538bb7f0c9814c2e0c1b0ffad96465061bf2f19ea5fbb0301be11abdcce253c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571d9ce1903e39c3633daeebf0b03403df596719739b78cec16793b12e6c5e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0444d592b81e4b48b53dd93ab75b76dcca01775500fb57a869d90309c65c674c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e312f2d67892e85e44e1188be106d1fbe49b4fd543824462e3ee7f7ce7b96f8"
  end

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
