require 'formula'

class Duff < Formula
  url 'http://downloads.sourceforge.net/project/duff/duff/0.5/duff-0.5.tar.gz'
  homepage 'http://duff.sourceforge.net/'
  md5 'e42bedb278ab41081df3ebb9ce1cbe1d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
