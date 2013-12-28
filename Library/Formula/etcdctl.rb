require 'formula'

class Etcdctl < Formula
  homepage 'https://github.com/coreos/etcdctl'
  url 'https://github.com/coreos/etcdctl/archive/v0.2.0.tar.gz'
  sha1 '6370bd86f3ab0264cf142db04c367e10e7f64a3d'
  head 'https://github.com/coreos/etcdctl.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'etcdctl'
  end
end
