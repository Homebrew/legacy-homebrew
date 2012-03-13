require 'formula'

class Duff < Formula
  url 'http://downloads.sourceforge.net/project/duff/duff/0.5.2/duff-0.5.2.tar.gz'
  homepage 'http://duff.sourceforge.net/'
  md5 '483f9216ebea14b090e0d71dbf7077ff'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
