require 'formula'

class Mosh < Formula
  url 'http://mosh-scheme.googlecode.com/files/mosh-0.2.7.tar.gz'
  homepage 'http://mosh.monaos.org'
  md5 '268598897536ff352296a905879940ad'

  depends_on 'gmp'
  depends_on 'oniguruma'

  fails_with_llvm "Inline asm errors"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
