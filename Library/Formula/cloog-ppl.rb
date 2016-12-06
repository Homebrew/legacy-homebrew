require 'formula'

class CloogPpl < Formula
  url 'ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz'
  homepage 'ftp://gcc.gnu.org/pub/gcc/infrastructure/'
  md5 '060ae4df6fb8176e021b4d033a6c0b9e'

  depends_on 'gmp'
  depends_on 'ppl'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gmp=#{prefix}",
                          "--with-bits=gmp",
                          "--with-ppl=#{prefix}"
    system "make install"
  end

end
