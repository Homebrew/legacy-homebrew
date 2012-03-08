require 'formula'

class Di < Formula
  homepage 'http://www.gentoo.com/di/'
  url 'http://gentoo.com/di/di-4.31.tar.gz'
  md5 'f324ec49888c6c642c998ee8c3a8ce21'

  def install
    system "make -e prefix=#{prefix}"
    system "make -e install prefix=#{prefix} DI_MANDIR=#{man1}"
  end
end
