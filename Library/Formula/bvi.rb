require 'formula'

class Bvi < Formula
  url 'http://downloads.sourceforge.net/bvi/bvi-1.3.2.src.tar.gz'
  homepage 'http://bvi.sourceforge.net'
  md5 '4257305ffb27177a6d5208b2df4ca92d'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
