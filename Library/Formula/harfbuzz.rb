# encoding: utf-8
class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.40.tar.bz2"
  sha256 "1771d53583be6d91ca961854b2a24fb239ef0545eed221ae3349abae0ab8321f"

  bottle do
    revision 1
    sha256 "e7a4f53b09310e122594f4036f41f13a80ff595372e3bfb09aaf2e3ad0ccbc0b" => :yosemite
    sha256 "0c0487f536b489f9594b7b416ff353a328e0bd9b872a14769154d9ce84cd243e" => :mavericks
    sha256 "2943b908ad3d5a9e431f2eb58a3b09270ae1d12713f8da1156d9dfc542edf13d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo"
  depends_on "icu4c" => :recommended
  depends_on "freetype"
  depends_on "gobject-introspection"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --with-gobject=yes
    ]

    args << "--with-icu" if build.with? "icu4c"
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
