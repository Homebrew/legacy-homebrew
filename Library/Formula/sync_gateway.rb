require "formula"

class SyncGateway < Formula
  homepage "http://docs.couchbase.com/sync-gateway"
  head "https://github.com/couchbase/sync_gateway.git", :branch => "master"
  url "https://github.com/couchbase/sync_gateway.git", :branch => "release/1.0.2"
  version "1.0.2"

  bottle do
    sha1 "c562b5a600af346900a97ffba3941ec7bf143cc3" => :mavericks
    sha1 "f0e322874588bc5328ec5ab4880def47026960e4" => :mountain_lion
    sha1 "b7b9d259e0ed15757f30b2e44881266d9dd2a4de" => :lion
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
