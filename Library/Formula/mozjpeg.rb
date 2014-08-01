require "formula"

class Mozjpeg < Formula
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v2.0.1.tar.gz"
  sha1 "466d570f85ae5296eaedf89de26a5dbe6db78407"

  head "https://github.com/mozilla/mozjpeg.git"

  bottle do
    cellar :any
    sha1 "c478f25b3a628e0c643de2eb3e3771660c5a4532" => :mavericks
    sha1 "0187b56d53c4535f47a88ba45d572a8c5472dac3" => :mountain_lion
    sha1 "c2d7ce459b09f4ebfa1bdc035e4fddffd1d8df8f" => :lion
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
    test_jpg = HOMEBREW_LIBRARY/"Homebrew/test/fixtures/test.jpg"
    system "#{bin}/jpegtran", "-crop", "1x1",
                              "-transpose", "-optimize",
                              "-outfile", "out.jpg",
                              test_jpg
  end
end
