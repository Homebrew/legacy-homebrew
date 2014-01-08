require 'formula'

class Etcd < Formula
  homepage 'https://github.com/coreos/etcd'
  url 'https://github.com/coreos/etcd/archive/v0.2.0.tar.gz'
  sha1 'c18bfe533a5c180012188e4039b740b9564894ce'
  head 'https://github.com/coreos/etcd.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'etcd'
  end
end
