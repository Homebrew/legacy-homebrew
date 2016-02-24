class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "http://mcmc-jags.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.0.1.tar.gz"
  sha256 "3619312cd9ce8163db4d5a51c961078061f6256382a2e93041ee22f7c09ba00e"

  bottle do
    cellar :any
    sha256 "577a74d952f74bf91cdae2f2875e6f043b3cb2b1e36fc6526b4e7b4e4a229916" => :el_capitan
    sha256 "afb532ef2c8a63ac692147455c4ecd4e5ac880bf059b03292a655bf759d1f1c1" => :yosemite
    sha256 "95729403ec9b2bcbec952998203bef95fda3d753c162f1a9753c6c8c59a535f7" => :mavericks
  end

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
