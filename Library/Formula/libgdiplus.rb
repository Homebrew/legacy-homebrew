class Libgdiplus < Formula
  desc "C-based implementation of the GDI+ API for Mono"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/tarball/79ae6cdb90163ba5eb601f8691ea9b7558d25371"
  head "https://github.com/mono/libgdiplus.git", using: :git, tag: "master"
  sha256 "0b84f8dd36e4e6df0877d66c816e7ef19892b52a552b1eed18e039bfb52d4de1"
  version "3.12" # latest tag = 3.12, plus two patches.

  # it depends on mono to link to System.Drawing
  depends_on "mono"
  depends_on "libexif"
  depends_on "glib"
  depends_on "cairo"
  depends_on :x11 => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  def install
    system "CPPFLAGS=-I/opt/X11/include ./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
