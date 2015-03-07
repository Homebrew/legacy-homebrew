require "formula"

class Libsigcxx < Formula
  homepage "http://libsigc.sourceforge.net"
  url "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.4/libsigc++-2.4.0.tar.xz"
  sha256 "7593d5fa9187bbad7c6868dce375ce3079a805f3f1e74236143bceb15a37cd30"

  bottle do
    revision 1
    sha1 "92cf0ff33a45ef65d21897c35b27596af3839d7d" => :yosemite
    sha1 "6d1f631fc0c08e0d1f424012c7fbc78010decf99" => :mavericks
    sha1 "9495301790cc50a4719afeb26658a9d43e3b58dd" => :mountain_lion
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
