class Shivavg < Formula
  desc "OpenGL based ANSI C implementation of the OpenVG standard"
  homepage "http://sourceforge.net/projects/shivavg/"
  url "https://downloads.sourceforge.net/project/shivavg/ShivaVG/0.2.1/ShivaVG-0.2.1.zip"
  sha256 "9735079392829f7aaf79e02ed84dd74f5c443c39c02ff461cfdd19cfc4ae89c4"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-example-all=no"
    system "make", "install"
  end
end
