require 'formula'

class Di < Formula
  homepage 'http://www.gentoo.com/di/'
  url 'http://gentoo.com/di/di-4.35.tar.gz'
  sha1 '989b03afb0bc40d4dbdcc8e2b6889cf2cf8e2852'

  def install
    system "make", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
    system "make", "install", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
  end

  test do
    system "#{bin}/di"
  end
end
