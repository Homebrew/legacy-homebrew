require 'formula'

class Mosh < Formula
  homepage 'http://mosh.monaos.org'
  url 'http://mosh-scheme.googlecode.com/files/mosh-0.2.7.tar.gz'
  sha1 '866c08ac12e14733ce27756001a27257624d01ad'

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
