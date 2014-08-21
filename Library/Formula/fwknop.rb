require "formula"

class Fwknop < Formula
  homepage "http://www.cipherdyne.org/fwknop/"
  head "https://github.com/mrash/fwknop.git"
  url "https://github.com/mrash/fwknop/archive/2.6.3.tar.gz"
  sha1 "ea83821d082e640bc70438f00578d3c049d4de8a"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gpgme"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gpgme"
    system "make install"
  end

  test do
    system "#{bin}/fwknop", "--version"
  end
end
