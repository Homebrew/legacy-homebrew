class Gpsbabel < Formula
  desc "GPSBabel converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "http://gpsbabel.googlecode.com/svn/trunk/gpsbabel", :revision => "4962"
  version "1.5.2"

  head "http://gpsbabel.googlecode.com/svn/trunk/gpsbabel"

  bottle do
    sha256 "029bee003e90047bfe0d68958e72c1aa638d8eb57aa70a176ef0585d71a9a548" => :yosemite
    sha256 "056e9b4f345b1b3fa8138e2381de434da7a5eb7a876859009f89905f9b5a4a61" => :mavericks
    sha256 "6a594e455bb92b69c35131f46fdd3eb3a651c012fa549fe927e8010dd6e4d4fd" => :mountain_lion
  end

  depends_on "libusb" => :optional
  depends_on "qt"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}", "--with-zlib=system"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end
end
