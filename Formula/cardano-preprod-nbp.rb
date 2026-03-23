class CardanoPreprodNbp < Formula
  desc "System service running non-block-producing preprod Cardano node"
  homepage "https://github.com/notunrandom/homebrew-cardano"
  url "file:///dev/null"
  version "10.6.2"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/cardano-preprod-nbp-10.6.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1af0dd6b7c99b586571ee3d67b7991d85cd421185e7703ada8d780a1e92a39c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432ee74c33af8bcb32a03bcd92b269088426c4362cf067a46cfb4cf0a07cb322"
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
