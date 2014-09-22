require "formula"

class Libsigcxx < Formula
  homepage "http://libsigc.sourceforge.net"
  url "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-2.4.0.tar.xz"
  sha256 "7593d5fa9187bbad7c6868dce375ce3079a805f3f1e74236143bceb15a37cd30"

  bottle do
    sha1 "c15edf433a6e99ef66188cf07007e4d64ac50b29" => :mavericks
    sha1 "b72366f4144c29d1c3cf2a0870d40a172fdfc185" => :mountain_lion
    sha1 "5acbd886f2a303837d0ab0013c4de766281925ef" => :lion
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
