require "formula"

class Libsigcxx < Formula
  homepage "http://libsigc.sourceforge.net"
  url "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-2.4.0.tar.xz"
  sha256 "7593d5fa9187bbad7c6868dce375ce3079a805f3f1e74236143bceb15a37cd30"

  bottle do
    sha1 "c3c2dd772631225eba25b4df6ce357a41f88af11" => :mavericks
    sha1 "f8270257d06a6cc5c178c243b3cfa3d44cb4a4c0" => :mountain_lion
    sha1 "dc6bebf72b9d3eb3d91117e4ccf503edb0b1293c" => :lion
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
