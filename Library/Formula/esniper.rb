class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "http://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.31.0/esniper-2-31-0.tgz"
  version "2.31"
  sha256 "30d2378c700b72b5363c8af59e7566564d9ec8cd4b44cd389c2830907d7bc676"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
