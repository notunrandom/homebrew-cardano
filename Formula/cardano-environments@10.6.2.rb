class CardanoEnvironmentsAT1062 < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/10.6.2.tar.gz"
  sha256 "8f4732d34471e4c0b88f5e69becbaa767534e1bca7493f901bc2d7fe4ece5a0e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-environments@10.6.2-10.6.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f335dbd69a9fe74087077cec1c8b6c15ba90122c1dd76d67c25146b66447334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7faf6350a6c0259a08e8003e3355c76780296c811c4e88288d143ab7ab01a95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f827d4ced17b0659f8d627d6d402d06fc45c3967bac607635712200900cbab64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5ca1cdd1198b55469c23cb03089eee690b7fa94b01f00292d77eeb38439e25"
  end

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
