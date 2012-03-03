require 'formula'

class Di < Formula
  homepage 'http://www.gentoo.com/di/'
  url 'http://gentoo.com/di/di-4.31.tar.gz'
  md5 'f324ec49888c6c642c998ee8c3a8ce21'

  def install
    system "make", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
    system "make", "install", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
  end

  def test
    system "#{bin}/di"
  end
end
