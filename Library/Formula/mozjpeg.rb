require "formula"

class Mozjpeg < Formula
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v2.1.tar.gz"
  sha1 "07f8df93cd54adbec37869833de987eb12ce7062"

  head "https://github.com/mozilla/mozjpeg.git"

  bottle do
    cellar :any
    sha1 "70e71c29b055c805f1e1cad0529078d76099e728" => :mavericks
    sha1 "afc0b5feceb012bfa03dc27528bb04c70d6195d4" => :mountain_lion
    sha1 "6e289260bb131bb2e4da792dc926ae245e8d7665" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-optimize",
                              "-outfile", "out.jpg",
                              test_fixtures("test.jpg")
  end
end
