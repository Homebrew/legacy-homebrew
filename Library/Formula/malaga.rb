class Malaga < Formula
  desc "Grammar development environment for natural languages"
  homepage "http://home.arcor.de/bjoern-beutel/malaga/"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/malaga_7.12.orig.tar.gz"
  sha256 "8811e5feaae03e1b6e3008116fdc7471a53b6c0c5036751c637b15058f855ace"

  bottle do
    cellar :any
    revision 1
    sha256 "86515c6fef935c0abe811d86baf10c5c6df341112d60c45ac04c01a37b096abf" => :yosemite
    sha256 "cfd527fb6022b4c1008bbfad1a6d1333b1b844bd720bc491610b8b6f9c9a1f8c" => :mavericks
    sha256 "55e08ee65f6d57bc84572c5778dc5c525711a8a5fcb102ddbb8751e3b6ffd8ae" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
