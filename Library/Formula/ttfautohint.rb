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
    sha256 "b4631261b1dd8fd7d30a849db5be19775cc8c21e706433ba1d929a3f74c24296" => :el_capitan
    sha1 "06db9ad73083d1a47515711fa5de47cb1b12fe4e" => :yosemite
    sha1 "dd81a451044381a3f87a8ad9d9da464744b98b80" => :mavericks
    sha1 "af5485546cb4fc3b6a663920ba9599f727e5fb11" => :mountain_lion
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
