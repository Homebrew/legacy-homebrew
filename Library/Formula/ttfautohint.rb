class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.4/ttfautohint-1.4.tar.gz"
  sha256 "7c518f56192235a091e533305b21edc0149f5a8e32c18b2a9ddf0c2746d7c14d"

  head do
    url "http://repo.or.cz/ttfautohint.git"
    depends_on "bison" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "e4dff4f8752aa5c9bf9ec94162e1fa9b2776b7cbfbd00f1b2278fde6a2bcdd31" => :el_capitan
    sha256 "1762395659fccf1dd00b8e5e941c2309d0e4cfa2791fa9d7d01569a1401068b6" => :yosemite
    sha256 "c13c5f5733170a7512af39932e523e47913964973967ff07884ecbafc9f5c66d" => :mavericks
  end

  option "with-qt", "Build ttfautohintGUI also"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "harfbuzz"
  depends_on "qt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-doc
    ]

    args << "--without-qt" if build.without? "qt"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    if build.with? "qt"
      system "#{bin}/ttfautohintGUI", "-V"
    else
      system "#{bin}/ttfautohint", "-V"
    end
  end
end
