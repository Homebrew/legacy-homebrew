class Libmpdec < Formula
  desc "mpdecimal is a package for correctly-rounded arbitrary precision decimal floating point arithmetic"
  homepage "http://www.bytereef.org/mpdecimal/index.html"
  url "http://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.4.1.tar.gz"
  sha256 "da74d3cfab559971a4fbd4fb506e1b4498636eb77d0fd09e44f8e546d18ac068"

  def install
    inreplace "libmpdec/Makefile.in", "-soname", "-install_name"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
