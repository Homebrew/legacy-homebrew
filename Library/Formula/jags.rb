class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "http://mcmc-jags.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.0.1.tar.gz"
  sha256 "3619312cd9ce8163db4d5a51c961078061f6256382a2e93041ee22f7c09ba00e"
  bottle do
    cellar :any
    sha256 "0fe2c73915572317e0e708bfe387fb3320ac8474afc4173b70d0b018ec0bdb33" => :el_capitan
    sha256 "00c6bf92d3d324c39fce886b061de737090ea98f3cadf02a360857ac0f302dc6" => :yosemite
    sha256 "78e2c2b112d80180c5578f9a1581b68bfd73d2fe7561903d2b4e177ccdd8932d" => :mavericks
    sha256 "5fd3ce491e4a7c7980359b9870d74d2ed7f90f35876d7de28ffd50f6c3e8eaff" => :mountain_lion
  end

  revision 1

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end 
