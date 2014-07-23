require "formula"

class Etcdctl < Formula
  homepage "https://github.com/coreos/etcdctl"
  url "https://github.com/coreos/etcdctl/archive/v0.4.5.tar.gz"
  sha1 "698704fa04d9308552e42ae7d2bd4ff15c193255"
  head "https://github.com/coreos/etcdctl.git"

  bottle do
    sha1 "220e279fe4e8ca7733c1b59618567c02a55596ff" => :mavericks
    sha1 "b43502e6c33f96bafb40191a30dc9fc2f922e88c" => :mountain_lion
    sha1 "5f3d423fbcb499fc0a8c8c9ee0c1b0df70b475db" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcdctl"
  end
end
