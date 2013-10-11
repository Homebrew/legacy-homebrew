require 'formula'

class Etcd < Formula
  homepage 'https://github.com/coreos/etcd'
  url 'https://github.com/coreos/etcd/archive/v0.1.2.tar.gz'
  sha1 'f6a644ec0ff30681b816bff192a881ed65d0c9e5'
  head 'https://github.com/coreos/etcd.git'

  depends_on 'go' => :build

  fails_with :clang do
    cause "clang: error: no such file or directory: 'libgcc.a'"
  end

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'etcd'
  end
end
