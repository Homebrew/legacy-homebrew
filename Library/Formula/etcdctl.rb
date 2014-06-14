require 'formula'

class Etcdctl < Formula
  homepage 'https://github.com/coreos/etcdctl'
  url 'https://github.com/coreos/etcdctl/archive/v0.4.3.tar.gz'
  sha1 '6ca73e6d3af5bb8b88a48f349dea9f200a663197'
  head 'https://github.com/coreos/etcdctl.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/etcdctl'
  end
end
