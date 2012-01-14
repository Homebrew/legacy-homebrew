require 'formula'

class Mpc2 < Formula
  url 'ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz'
  md5 '5b34aa804d514cc295414a963aedb6bf'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    #ENV.gcc_4_2

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-checking=release",
      "--with-gmp=#{HOMEBREW_PREFIX}", "--with-mpfr=#{HOMEBREW_PREFIX}", "--with-mpc=#{HOMEBREW_PREFIX}" #, "--program-suffix=-4.6.1"

    system "echo '#define GMP_RNDA MPFR_RNDA' >> config.h"
    system "make install"
  end
end
