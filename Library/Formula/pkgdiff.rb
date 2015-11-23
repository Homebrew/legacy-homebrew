class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.6.3.tar.gz"
  sha256 "80d5bdec415db2627c3da2f086a4172791a667a0bbb33743a0c84a49b8ce3332"

  bottle do
    cellar :any
    sha256 "c74cfbd52e81aebeb30cd3a7439310cfc738ff84fa10e96b3e755d513d71eed6" => :yosemite
    sha256 "9d272b363b8188686ce6eafa1e7edf7a1b5e1264c5ea944cfc88835c0e259f43" => :mavericks
    sha256 "b3b592c5186b5943db228fbda09893e1009df20e59e7504dd3501e5fd53f48af" => :mountain_lion
  end

  depends_on "wdiff"
  depends_on "gawk"
  depends_on "binutils" => :recommended
  depends_on "rpm" => :optional
  depends_on "dpkg" => :optional

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system "pkgdiff"
  end
end
