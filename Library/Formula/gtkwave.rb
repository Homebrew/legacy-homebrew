require 'formula'

class Gtkwave < Formula
  homepage 'http://gtkwave.sourceforge.net/'
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.31.tar.gz'
  md5 'brary/Caches/Homebrew/gtkwave-3.'

  depends_on 'gtk+'
  depends_on 'xz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system 'make install'
  end
end
