require "formula"

class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "http://ftpmirror.gnu.org/libunistring/libunistring-0.9.4.tar.xz"
  mirror "ftp://ftp.gnu.org/gnu/libunistring/libunistring-0.9.4.tar.xz"
  sha1 "d77548d7a991452837decf3fa40cc985c7451735"

  bottle do
    cellar :any
    revision 1
    sha1 "1f35bb79d8ad29a548b45d452fc5ef2d256a4902" => :yosemite
    sha1 "6215541c636e09cb550f18b6947b484dc37dc976" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
