require 'formula'

class Gv < Formula
  url 'http://ftpmirror.gnu.org/gv/gv-3.7.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gv/gv-3.7.2.tar.gz'
  homepage 'http://www.gnu.org/s/gv/'
  md5 'eb47d465755b7291870af66431c6f2e1'

  depends_on 'ghostscript'
  depends_on 'xaw3d'

  skip_clean 'share/gv/safe-gs-workdir'

  def patches
    # apply MacPorts typedef patch
    { :p0 => "https://trac.macports.org/export/83941/trunk/dports/print/gv/files/patch-src-callbacks.c.diff" }
  end

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-SIGCHLD-fallback"
    system "make install"
  end
end
