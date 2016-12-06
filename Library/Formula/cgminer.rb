require 'formula'

class Cgminer < Formula
  homepage 'https://github.com/ckolivas/cgminer'
  url 'http://ck.kolivas.org/apps/cgminer/2.11/cgminer-2.11.0.tar.bz2'
  sha1 '2bb42929778c07275fbf9b280598d8679f1e1aad'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-scrypt"
    system "make install"
  end

  test do
    system "cgminer -V"
  end
end
