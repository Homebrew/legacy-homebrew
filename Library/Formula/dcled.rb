class Dcled < Formula
  desc "Linux driver for dream cheeky USB message board"
  homepage "https://www.jeffrika.com/~malakai/dcled/index.html"
  url "https://www.jeffrika.com/~malakai/dcled/dcled-2.2.tgz"
  sha256 "0da78c04e1aa42d16fa3df985cf54b0fbadf2d8ff338b9bf59bfe103c2a959c6"

  bottle do
    cellar :any
    sha256 "53d07c9548eaeba12645e944ce92c27a02667758176815220dc4ee2a8945c661" => :el_capitan
    sha256 "2ead7c4eb3c170690890c294936a2d3fc39def2fc332ce4c1da6d17cc8f91b50" => :yosemite
    sha256 "47a0b2e1eba58932936c25726d631d19f0f2a0a7b8872aff9e1d3a83b4e3cfc9" => :mavericks
  end

  depends_on "libhid"
  depends_on "libusb"

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBUSB_CFLAGS=-I#{Formula["libusb"].opt_include}/libusb-1.0"
    system "make", "install",
                   "FONTDIR=#{share}/#{name}",
                   "INSTALLDIR=#{bin}"
  end
end
