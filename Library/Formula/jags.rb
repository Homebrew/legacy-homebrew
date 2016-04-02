class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "http://mcmc-jags.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.2.0.tar.gz"
  sha256 "af3e9d2896d3e712f99e2a0c81091c6b08f096650af6aa9d0c631c0790409cf7"

  bottle do
    cellar :any
    sha256 "3a097289424b68d96d21eebaba46c72919d14fd69d696ce2bd879d309dd3a662" => :el_capitan
    sha256 "998b753d66f973ac321b95c73a630ff325e5543f911ad2c66b782bb6d36fa63e" => :yosemite
    sha256 "07da5d6b1faff0492d3e808d08529b1466dada956ce0454fbe89b522e3dfda9f" => :mavericks
  end

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
