require 'formula'

class Puf < Formula
  url 'http://downloads.sourceforge.net/project/puf/puf/1.0.0/puf-1.0.0.tar.gz'
  homepage 'http://puf.sourceforge.net/'
  md5 '78f870f2a0c611ace8c5e9ced7b08a83'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
