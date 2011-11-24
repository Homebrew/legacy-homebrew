require 'formula'

class Jags < Formula
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/3.x/Source/JAGS-3.1.0.tar.gz'
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  md5 '1f84163a3e5114d30d7832fc26e54acf'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    system "chmod +x #{bin}/jags"
  end
end
