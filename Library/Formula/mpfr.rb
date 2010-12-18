require 'formula'

class Mpfr <Formula
  url 'http://www.mpfr.org/mpfr-3.0.0/mpfr-3.0.0.tar.bz2'
  homepage 'http://www.mpfr.org/'
  md5 'f45bac3584922c8004a10060ab1a8f9f'

  depends_on 'gmp'

  def patches
    {:p1 => ['http://www.mpfr.org/mpfr-3.0.0/allpatches']}
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
