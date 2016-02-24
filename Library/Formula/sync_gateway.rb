class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag => "1.1.1",
      :revision => "2fff9eb1edbbb907359c8233c958205a885d8ca3"

  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20d6523b8f7ded2362a4df137757cbb31b4b6bb95b3edb4a62533a85e23aee27" => :el_capitan
    sha256 "e8c8d9601402296641338ae1349f6e4b9f20477c5c0ddacffcfec7c4d40e48c7" => :yosemite
    sha256 "1ac9b9e256e74a9732a1c5a28aaf78fd6c9e843f831910ffeab7ca6ee9805259" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "buildit"
    bin.install "bin/sync_gateway"
  end

  test do
    pid = fork { exec "#{bin}/sync_gateway" }
    sleep 1
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
