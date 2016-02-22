class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.gz"
  sha256 "8baccf663553b62977b1c017d18b3879835da0ef79dc4d3b708f2566762f1d5e"

  bottle do
    cellar :any
    sha256 "abee4670d1a58fcbf57e180aa31543f42f84abda4c5f88212a0baea480819633" => :el_capitan
    sha256 "f0154b4f829949c2187e94515b3ff9319a83d8c20d2143df14514d19560b0f0c" => :yosemite
    sha256 "7fed313daf90cb1949d943a8edecced7a4c9616af5bc862218bbc7bb8a8c54a6" => :mavericks
  end

  head do
    url "https://github.com/libass/libass.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-fontconfig", "Disable CoreText backend in favor of the more traditional fontconfig"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz" => :recommended
  depends_on "fontconfig" => :optional

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-coretext" if build.with? "fontconfig"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
