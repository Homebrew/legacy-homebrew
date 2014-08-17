require "formula"

class Fsv < Formula
  homepage "http://fsv.sourceforge.net/"
  url "https://github.com/mcuelenaere/fsv.git", :tag => "fsv-0.9-1"
  version "0.9.1"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :x11
  depends_on "gtk+"
  depends_on "gtkglarea"

  def install
    ENV["LIBTOOLIZE"] = "glibtoolize"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
