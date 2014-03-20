require 'formula'

class Di < Formula
  homepage 'http://www.gentoo.com/di/'
  url 'http://gentoo.com/di/di-4.34.tar.gz'
  sha1 '5be548368bb795303f11cff340f3bbc659f892cd'

  def install
    system "make", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
    system "make", "install", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
  end

  test do
    system "#{bin}/di"
  end
end
