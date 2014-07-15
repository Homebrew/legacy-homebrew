require "formula"

class Mozjpeg < Formula
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v2.0.1.tar.gz"
  sha1 "466d570f85ae5296eaedf89de26a5dbe6db78407"

  head "https://github.com/mozilla/mozjpeg.git"

  bottle do
    cellar :any
    sha1 "77a8c981cda61d97804d155484f7ea89a0a729b3" => :mavericks
    sha1 "bff1e31287c8e23c91d5254b20288f93e0494e2d" => :mountain_lion
    sha1 "2438fd34c748e6b4ff39ef9f3c66a7864b10b71c" => :lion
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
    system "#{bin}/jpegtran", "-crop", "500x500+200+500",
                              "-transpose", "-optimize",
                              "-outfile", "test.jpg",
                              "/System/Library/CoreServices/DefaultDesktop.jpg"
  end
end
