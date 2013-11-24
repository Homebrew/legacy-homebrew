require 'formula'

class Jigdo < Formula
  homepage 'http://atterer.org/jigdo/'
  url 'http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2'
  sha1 '7b83c35af71f908b31b9aa55b0dda9dfb4d224f0'

  depends_on 'pkg-config' => :build
  depends_on 'berkeley-db'
  depends_on 'gtk+'

  # Use MacPorts patch for compilation on 10.9; this software is no longer developed.
  def patches
    { :p0 => "http://trac.macports.org/export/113020/trunk/dports/net/jigdo/files/patch-src-compat.hh.diff" }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/jigdo-file", "-h"
  end
end
