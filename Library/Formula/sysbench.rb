require "formula"

class Sysbench < Formula
  homepage "http://sysbench.sourceforge.net/"
  url "http://ftp.de.debian.org/debian/pool/main/s/sysbench/sysbench_0.4.12.orig.tar.gz"
  sha1 "3f346e8b29b738711546970b027bbb7359d4672a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

  def install
    inreplace "configure.ac", "AC_PROG_LIBTOOL", "AC_PROG_RANLIB"
    system "./autogen.sh"

    args = ["--prefix=#{prefix}"]
    if build.with? "mysql"
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end
    args << "--with-psql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end
end
