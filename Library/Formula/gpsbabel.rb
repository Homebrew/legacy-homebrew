class Gpsbabel < Formula
  desc "GPSBabel converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_3.tar.gz"
  sha256 "10b7aaca44ce557fa1175fec37297b8df55611ab2c51cb199753a22dbf2d3997"

  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    sha256 "029bee003e90047bfe0d68958e72c1aa638d8eb57aa70a176ef0585d71a9a548" => :yosemite
    sha256 "056e9b4f345b1b3fa8138e2381de434da7a5eb7a876859009f89905f9b5a4a61" => :mavericks
    sha256 "6a594e455bb92b69c35131f46fdd3eb3a651c012fa549fe927e8010dd6e4d4fd" => :mountain_lion
  end

  depends_on "libusb" => :optional
  depends_on "qt"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end
end
