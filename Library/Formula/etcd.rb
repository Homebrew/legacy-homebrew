require 'formula'

class Etcd < Formula
  homepage 'https://github.com/coreos/etcd'
  url 'https://github.com/coreos/etcd/archive/v0.3.0.tar.gz'
  sha1 '0f191070268f7c87ca044ad23179995b9290e3c0'
  head 'https://github.com/coreos/etcd.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/etcd'
  end
end
