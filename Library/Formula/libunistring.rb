require "formula"

class Libunistring < Formula
  homepage "https://www.gnu.org/software/libunistring/"
  url "http://ftpmirror.gnu.org/libunistring/libunistring-0.9.4.tar.xz"
  mirror "ftp://ftp.gnu.org/gnu/libunistring/libunistring-0.9.4.tar.xz"
  sha1 "d77548d7a991452837decf3fa40cc985c7451735"

  bottle do
    cellar :any
    sha1 "bd04ffb1891146a22737513b3b854080042912eb" => :mavericks
    sha1 "e131611c0be53ad4e612ecd1ac605d684a3db3a7" => :mountain_lion
    sha1 "baddc77f72ff77534c7320a3ffef3f2639b2616b" => :lion
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
