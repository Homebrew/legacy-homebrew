require 'formula'

class Gv < Formula
  homepage 'http://www.gnu.org/s/gv/'
  url 'ftp://alpha.gnu.org/gnu/gv/gv-3.7.3.90.tar.gz'
  sha1 'd7820c770e595c93b5fe1ea50776ae11d0decfac'

  # Note: Switch back to ftp://ftp.gnu.org/gnu/gv/ @ gv-3.7.4.
  # This gv version from alpha was released to support libxaw3d >= 1.6.1

  depends_on 'ghostscript'
  depends_on :x11 => '2.7.2'

  skip_clean 'share/gv/safe-gs-workdir'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-SIGCHLD-fallback"
    system "make install"
  end
end
