class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "http://mcmc-jags.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/3.x/Source/JAGS-3.4.0.tar.gz"
  sha256 "2beaa9a2672c2c95efc55ffa4c8b597a872f20232373daebd17ad539d3d7d82b"
  bottle do
    cellar :any
    sha1 "ea59e194feb354ef474a6bd58d4556d0e68adfb0" => :yosemite
    sha1 "e3d0935caaf8a06b11efd1338d5444fdce87dc63" => :mavericks
    sha1 "49977edf0dc1571ae846f758c3ba74cf59a2f0f5" => :mountain_lion
  end

  revision 1

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
