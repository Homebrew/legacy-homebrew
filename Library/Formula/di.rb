require 'formula'

class Di < Formula
  homepage 'http://www.gentoo.com/di/'
  url 'http://gentoo.com/di/di-4.31.tar.gz'
  sha1 '2a7212e03286b68ebb4783ae8937999145165c79'

  def install
    system "make", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
    system "make", "install", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
  end

  def test
    system "#{bin}/di"
  end
end
