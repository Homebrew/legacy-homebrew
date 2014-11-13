require 'formula'

class Libssh2 < Formula
  homepage "http://www.libssh2.org/"
  url "http://www.libssh2.org/download/libssh2-1.4.3.tar.gz"
  sha1 "c27ca83e1ffeeac03be98b6eef54448701e044b0"
  revision 1

  head do
    url "git://git.libssh2.org/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 2
    sha1 "6e9fd52d513692ea5db968de524dbe2b81e2f018" => :yosemite
    sha1 "bbe16ac0d85f7aed7794ba5f2220aa3a533298aa" => :mavericks
    sha1 "6de15a0a9400554c51858092e0276bb9ddd15c42" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./buildconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libssl-prefix=#{Formula['openssl'].opt_prefix}",
                          "--with-libz"
    system "make install"
  end
end
