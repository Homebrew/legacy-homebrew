class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.gz"
  sha256 "8baccf663553b62977b1c017d18b3879835da0ef79dc4d3b708f2566762f1d5e"

  bottle do
    cellar :any
    sha256 "42dee7014867f9f5bf6e3445cf57852787a998d135810e5ce1fb6a7ce2d248e2" => :el_capitan
    sha256 "1f7975c1178ed0e9fe4131ed41acbbb7f4dd83571dea9a032376345ddb7dd12c" => :yosemite
    sha256 "6e3562ebf794ba2337163f63dcdb0a69e2e5b39636d724be4bbbb2de3bd5ee41" => :mavericks
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
