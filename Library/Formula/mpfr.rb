require 'formula'

class Mpfr <Formula
  url 'http://www.mpfr.org/mpfr-current/mpfr-2.4.2.tar.bz2'
  homepage 'http://www.mpfr.org/'
  md5 '89e59fe665e2b3ad44a6789f40b059a0'

  depends_on 'gmp'

  def patches
    {:p1 => ['http://www.mpfr.org/mpfr-current/allpatches']}
  end

  def install
      configure_args = [
          "--prefix=#{prefix}",
          "--disable-debug",
          "--disable-dependency-tracking",
      ]
    system "./configure", *configure_args
    system "make install"
  end
end
