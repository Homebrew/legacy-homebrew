class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.0.2.tar.gz"
  sha256 "03d717a59d9518c2330ecbadb4f6b6870e8bad07f970ca7d4fd40d085637e259"

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
