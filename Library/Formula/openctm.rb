require 'formula'

class Openctm < Formula
  homepage 'http://openctm.sourceforge.net'
  url 'http://sourceforge.net/projects/openctm/files/OpenCTM-1.0.3/OpenCTM-1.0.3-src.tar.bz2'
  sha1 '7acfda356b3fa5393d993001ffeaa0e6aa2f65da'

  depends_on 'gtk+'

  def install
    system "make", "-f", "Makefile.macosx"

    system "mkdir", "-p", lib, include, bin, man1
    system "make", "LIBDIR=#{lib}",
                   "INCDIR=#{include}",
                   "BINDIR=#{bin}",
                   "MAN1DIR=#{man1}",
                   "-f", "Makefile.macosx", "install"
  end

  test do
    system "#{bin}/ctmconv"
  end
end
