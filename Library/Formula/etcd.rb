require 'formula'

class Etcd < Formula
  homepage 'https://github.com/coreos/etcd'
  url 'https://github.com/coreos/etcd/archive/v0.1.1.tar.gz'
  sha1 '60f39379b7f916a7e3e87fdefc1104cd2330c1ae'
  head 'https://github.com/coreos/etcd.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'etcd'
  end
end
