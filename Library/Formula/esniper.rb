class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.31.0/esniper-2-31-0.tgz"
  version "2.31"
  sha256 "30d2378c700b72b5363c8af59e7566564d9ec8cd4b44cd389c2830907d7bc676"

  bottle do
    cellar :any_skip_relocation
    sha256 "d73b509b0e6350ec85ca5719c130b4c2aa0733a0c45748dd8dd616201babb53b" => :el_capitan
    sha256 "bb0bd9ade19fe5ce06e90012a524692aacffa9d15940f4ea2986f429549288e3" => :yosemite
    sha256 "fe731e40a8b00d5a5dda9628a16b9debc0b44653f822abbc2f18739e45e8147d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
