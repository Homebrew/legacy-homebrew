require "formula"

class Etcdctl < Formula
  homepage "https://github.com/coreos/etcdctl"
  url "https://github.com/coreos/etcdctl/archive/v0.4.6.tar.gz"
  sha1 "924668c26a30bfe65ac88971965b1dad819be630"
  head "https://github.com/coreos/etcdctl.git"

  bottle do
    sha1 "55d9d167c681bde77edddafab93ca59a7f6ac876" => :mavericks
    sha1 "f371b74df8c7efd4b20bf51eec88621f6129b0c1" => :mountain_lion
    sha1 "0944b857b23a28b4bc1c20c668d07afbf86b42cf" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcdctl"
  end
end
