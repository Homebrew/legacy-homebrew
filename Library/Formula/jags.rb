require 'formula'

class Jags < Formula
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/3.x/Source/JAGS-3.3.0.tar.gz'
  sha1 '79a50baaf1e2b2e7673d477e830963b49aad2a6c'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
