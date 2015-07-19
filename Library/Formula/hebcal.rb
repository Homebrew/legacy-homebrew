class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v3.18.tar.gz"
  sha256 "5aa1d3f7c759b198dfaf115649a46f9861618989490cb341feec64565ddac761"

  bottle do
    cellar :any
    sha256 "94db6e8f80e482fcb7785109d227d8cc9855f064c994048014e79c08e639730f" => :yosemite
    sha256 "7439a93a1826a9c4839e3d766848e045ebcd53e13a70bffe9d9b1db233b1604f" => :mavericks
    sha256 "b82ab16bfcf545ac7aa67293575c9a7592ec97a9302d5a4f83956f829469afe2" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
