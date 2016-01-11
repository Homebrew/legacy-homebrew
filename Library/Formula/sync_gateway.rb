class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  head "https://github.com/couchbase/sync_gateway.git"
  url "https://github.com/couchbase/sync_gateway.git", :branch => "release/1.0.4"
  version "1.0.4"

  bottle do
    cellar :any
    sha256 "bcdb6482c2e6c484d930ffe5e5e35b2cc8aeeb10606bfc520f9e0c2b6bbb6ddb" => :yosemite
    sha256 "01123f7a5c82bbc6d2e11094416a8ac63fd0b8c0575e7b942f5cf2cc8bb50495" => :mavericks
    sha256 "7eac953de233b84b5b28e16cf5baab41ae3c4acc5c54e1f1abb0c5aa4c2117f6" => :mountain_lion
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
