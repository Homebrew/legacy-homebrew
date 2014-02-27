require "formula"

class SyncGateway < Formula
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git", :tag => "1.0-beta2"
  head "https://github.com/couchbase/sync_gateway.git", :branch => "master"

  depends_on "go" => :build

  def install
    if build.head?
      system "make", "buildit"
    else
      ENV["GOBIN"] = "#{Dir.pwd}/bin"
      system "./go.sh", "install", "-v", "github.com/couchbaselabs/sync_gateway"
      bin.install "bin/sync_gateway"
    end
  end

  test do
    pid = fork { exec "#{bin}/sync_gateway" }
    sleep 1
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
