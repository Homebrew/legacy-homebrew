class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
  sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"

  bottle do
    cellar :any
    revision 1
    sha1 "1fe8e32e25366b24b3de3d9ccbf7c72315fc482f" => :yosemite
    sha1 "5763fbd3bde4d3866b44ea19f841b52b271dfc3b" => :mavericks
    sha1 "fecff8034949f3b22782d21b3191826d40bb2e1e" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
