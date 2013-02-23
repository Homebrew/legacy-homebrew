require 'formula'

class Gtmess < Formula
  homepage 'http://gtmess.sourceforge.net/'
  url 'http://sourceforge.net/projects/gtmess/files/gtmess/0.97/gtmess-0.97.tar.gz'
  sha1 '9fbbb85554e7e8834e399e5b1d6869af6e2975bc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
