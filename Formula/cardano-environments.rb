class CardanoEnvironments < Formula
  desc "Versioned copy of configuration files for Cardano networks"
  homepage "https://github.com/notunrandom/cardano-environments"
  url "https://github.com/notunrandom/cardano-environments/archive/refs/tags/11.0.1.tar.gz"
  sha256 "e920d38a6f4e2b23e591040530e515e770075f3cb4ce2e51e7eafcb1082bf7ae"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-environments-11.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddaecf8d60ad8badb4bb9685e649268587828cac4d72795d80b4a63d73dc5161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7442951ec1e81edec9a9040d4a318ff95aed7cfbff99b89d729b37d75884e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6344fe371666ea5bdef98931d54c744f912737776fcb2299af2f945e3ff22bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327d076e43d57721619541ec59a562c52b45a84169497fb5966e6d19aeb8f38f"
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
