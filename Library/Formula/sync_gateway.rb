require "formula"

class SyncGateway < Formula
  homepage "http://docs.couchbase.com/sync-gateway"
  head "https://github.com/couchbase/sync_gateway.git", :branch => "master"
  url "https://github.com/couchbase/sync_gateway.git", :branch => "release/1.0.2"
  version "1.0.2"

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
