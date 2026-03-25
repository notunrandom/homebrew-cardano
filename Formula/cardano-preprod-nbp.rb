class CardanoPreprodNbp < Formula
  desc "System service running non-block-producing preprod Cardano node"
  homepage "https://github.com/notunrandom/homebrew-cardano"
  url "file:///dev/null"
  version "10.6.2"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-preprod-nbp-10.6.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e116fb0acfb5120bf7b843404b38f4187c636c8f0993f69237d8b15d5f784fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ee0f3ce691754c765c2525d933444dd0197e748a49d260843c712cebe78bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f299a1a494e37299aaf23337bc639b27d4efd738bf54a95f6a76c602e9ef243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0615a7490e25b42f3a493f52d94f99be24cde803c0479a4e159ea7e217fac650"
  end

  depends_on "notunrandom/cardano/cardano-environments"
  depends_on "notunrandom/cardano/cardano-node"

  def install
    (prefix/"placeholder").write("")
    (var/"cardano"/"preprod"/"db").mkpath
  end

  service do
    run [
      HOMEBREW_PREFIX/"opt"/"cardano-node"/"bin"/"cardano-node",
      "run",
      "--config", etc/"cardano"/"preprod"/"config.json",
      "--topology", etc/"cardano"/"preprod"/"topology.json",
      "--database-path", var/"cardano"/"preprod"/"db",
      "--socket-path", var/"cardano"/"preprod"/"node.socket",
      "--port", "3001"
    ]
    keep_alive true
    log_path var/"cardano"/"preprod"/"log"
    error_log_path var/"cardano"/"preprod"/"log"
  end

  test do
    assert_path_exists var/"cardano"/"preprod"/"db"
  end
end
