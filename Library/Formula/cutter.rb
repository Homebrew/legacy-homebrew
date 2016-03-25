class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "http://cutter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.5/cutter-1.2.5.tar.gz"
  sha256 "e53613445e8fe20173a656db5a70a7eb0c4586be1d9f33dc93e2eddd2f646b20"
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "8c1680aeae7279a5ea6baa71299f25cff015ccc7085bbdf468962f505cb79ca6" => :el_capitan
    sha256 "94d199ff3bd76e593e6f14953c62a1ff9bc11d012a52d825dbfee52813d6be54" => :yosemite
    sha256 "f4a22bcd3bed4ab5b4d536bd61613a0b526f390376fa614ed67f682f71339def" => :mavericks
    sha256 "ce4d7aed7be9b99111e4515c617bd3c2e6a2bdcae8bca9c1a52f9d463747fa2a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
