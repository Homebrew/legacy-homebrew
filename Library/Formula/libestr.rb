require 'formula'

class Libestr < Formula
  homepage 'http://libestr.adiscon.com'
  url "http://libestr.adiscon.com/files/download/libestr-0.1.9.tar.gz"
  sha1 "55fb6ad347f987c45d98b422b0436d6ae50d86aa"

  bottle do
    cellar :any
    sha1 "bc0dc2d4fc17dce269003705c01cda62482b58a3" => :mavericks
    sha1 "e232f60fdda3548f5f39b48221a018b363554e8c" => :mountain_lion
    sha1 "e955560fd837eacbc843c631a1e5aaa432802942" => :lion
  end

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
