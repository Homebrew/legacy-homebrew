class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.0.1.tar.bz2"
  sha256 "32a1a7ad584a2f2cfba5c1d234d046c0521e86e7a21d403e15e89aa509ef0ea8"

  bottle do
    sha256 "89ef0eac9a10ee07293bc769663c55368eef6af6e0cd4faa9798b72bd5dd336d" => :yosemite
    sha256 "9bf6b6d48271957398aa2db68ec0df65e55fc488ce55c64ad811c68595ba53ca" => :mavericks
    sha256 "42a8ee7134fe0bd07b0c2aad7bde033e7be721dee43970a414764868f6754a15" => :mountain_lion
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
