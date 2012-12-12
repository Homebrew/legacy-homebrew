require 'formula'

class Bvi < Formula
  url 'http://downloads.sourceforge.net/bvi/bvi-1.3.2.src.tar.gz'
  homepage 'http://bvi.sourceforge.net'
  sha1 '0ff213ebb5cd0993c5d1f7c8d4172aaec709aac1'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
