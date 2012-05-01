require 'formula'

class Gv < Formula
  url 'http://ftpmirror.gnu.org/gv/gv-3.7.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gv/gv-3.7.3.tar.gz'
  homepage 'http://www.gnu.org/s/gv/'
  md5 '98ae3e9ce338b64ba5ab622389c5960e'

  depends_on 'ghostscript'
  depends_on 'xaw3d'

  skip_clean 'share/gv/safe-gs-workdir'

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-SIGCHLD-fallback"
    system "make install"
  end
end
