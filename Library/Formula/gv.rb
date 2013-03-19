require 'formula'

class Gv < Formula
  homepage 'http://www.gnu.org/s/gv/'
  url 'http://ftpmirror.gnu.org/gv/gv-3.7.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gv/gv-3.7.4.tar.gz'
  sha1 'd5bc11a37136dff69248f943a632544a4036b63f'

  depends_on 'pkg-config' => :build
  depends_on 'ghostscript' => 'with-x11'
  depends_on :x11 => '2.7.2'

  skip_clean 'share/gv/safe-gs-workdir'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-SIGCHLD-fallback"
    system "make install"
  end
end
