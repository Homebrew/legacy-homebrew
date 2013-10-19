require 'formula'

class Etcdctl < Formula
  homepage 'https://github.com/coreos/etcdctl'
  url 'https://github.com/coreos/etcdctl/archive/v0.1.2.tar.gz'
  sha1 '93befc2b5a9951ba6e9a94a969535ee8d695e693'
  head 'https://github.com/coreos/etcdctl.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'etcdctl'
  end
end
