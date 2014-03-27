require 'formula'

class Etcdctl < Formula
  homepage 'https://github.com/coreos/etcdctl'
  url 'https://github.com/coreos/etcdctl/archive/v0.3.0.tar.gz'
  sha1 '3bc5fae34d40c1717e82a7af4ed177c62dbe22af'
  head 'https://github.com/coreos/etcdctl.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/etcdctl'
  end
end
