require 'formula'

class Jags < Formula
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/3.x/Source/JAGS-3.2.0.tar.gz'
  sha1 '020df50df98e066b261db77b061d8d8d354bf72b'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
