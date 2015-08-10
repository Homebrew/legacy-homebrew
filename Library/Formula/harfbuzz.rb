class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.0.1.tar.bz2"
  sha256 "32a1a7ad584a2f2cfba5c1d234d046c0521e86e7a21d403e15e89aa509ef0ea8"

  bottle do
    revision 1
    sha256 "dd0d8b2a405d179f4bb40686d22bd1a8295b0e978db66c223f44ccb329fe8ecd" => :yosemite
    sha256 "71e8b23e62d0237da679fbbacb5383ef49a388ea8f5d69d36a914df9d0280fa9" => :mavericks
    sha256 "fb1a7e27a58de81b25f33a5a84cdb7fc26878505b2c3a00370ab130b95854e3f" => :mountain_lion
  end

  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo" => :optional
  depends_on "icu4c" => :recommended
  depends_on "graphite2" => :optional
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
    args << "--with-graphite2" if build.with? "graphite2"
    args << "--with-cairo" if build.with? "cairo"
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
