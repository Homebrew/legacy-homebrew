class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  head "https://github.com/couchbase/sync_gateway.git"
  url "https://github.com/couchbase/sync_gateway.git", :branch => "release/1.0.4"
  version "1.0.4"

  bottle do
    cellar :any
    sha1 "cd5eef55308a0cbbfbd92e774b86d47344abea7e" => :yosemite
    sha1 "6b9a112f3ff48989aea5380e8b7bcbccf7a6b385" => :mavericks
    sha1 "daff7035dd82ab3c9f44a521ab1ea99f93a10343" => :mountain_lion
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
