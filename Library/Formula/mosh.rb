require 'formula'

class Mosh < Formula
  homepage 'http://mosh.monaos.org'
  url 'http://mosh-scheme.googlecode.com/files/mosh-0.2.7.tar.gz'
  md5 '268598897536ff352296a905879940ad'

  depends_on 'gmp'
  depends_on 'oniguruma'

  fails_with :llvm do
    cause "Inline asm errors"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
