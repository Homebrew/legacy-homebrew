require 'formula'

class Mpfi < Formula
  homepage 'http://perso.ens-lyon.fr/nathalie.revol/software.html'
  url 'https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz'
  md5 '2787d2fab9ba7fc5b171758e84892fb5'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "make check"
  end
end
