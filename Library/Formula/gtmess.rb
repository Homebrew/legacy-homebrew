require 'formula'

class Gtmess < Formula
  homepage 'http://gtmess.sourceforge.net/'
  url 'http://sourceforge.net/projects/gtmess/files/gtmess/0.97/gtmess-0.97.tar.gz'
  md5 'd9526ffd117a22283f477cb15d05807e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
