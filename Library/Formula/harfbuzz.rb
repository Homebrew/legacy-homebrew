# encoding: utf-8
class Harfbuzz < Formula
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.40.tar.bz2"
  sha256 "1771d53583be6d91ca961854b2a24fb239ef0545eed221ae3349abae0ab8321f"

  bottle do
    cellar :any
    sha256 "68a58bf28ebd0cb7d8ef3885aa86704f442c15e2c22216debddfb7184a49c3a9" => :yosemite
    sha256 "374db121d1c3b0182ac121dad24539f408588bf5c60391f7f90002e568cc9c60" => :mavericks
    sha256 "3a3c89c3ac78239f166ee386a94ba9e3beb263fa7e252eadd655f22af7ab79e3" => :mountain_lion
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
