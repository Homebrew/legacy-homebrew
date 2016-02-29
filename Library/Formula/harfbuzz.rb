class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.2.1.tar.bz2"
  sha256 "0c189aa386c5ea8d7c315adf273f56f48f412081a367b3f92abc2d0855fa2226"

  bottle do
    sha256 "12d4c38f7439d006576b9d62a166fe9afaaecc1f492315fa4a12218f4e386b5f" => :el_capitan
    sha256 "fe3a9f633dc4a362b5da189aef75876ecced95c02f135194a49bcb70975cc5b0" => :yosemite
    sha256 "090ed0da8d673b16a6574b60a62d99c71d3a958ba863548f5ae4f2d71cb58a4c" => :mavericks
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "freetype"
  depends_on "gobject-introspection"
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional
  depends_on "graphite2" => :optional

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --with-gobject=yes
      --with-coretext=yes
      --enable-static
    ]

    args << "--with-icu" if build.with? "icu4c"
    args << "--with-graphite2" if build.with? "graphite2"
    args << "--with-cairo" if build.with? "cairo"

    system "./autogen.sh" if build.head?
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
