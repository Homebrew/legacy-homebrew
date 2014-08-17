require 'formula'

class Jags < Formula
  homepage 'http://mcmc-jags.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mcmc-jags/JAGS/3.x/Source/JAGS-3.4.0.tar.gz'
  sha1 '129a8f97da91877473f209c67f1f9c5b04173586'

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
