class Ttfautohint < Formula
  desc "Automated hinting process for web fonts"
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.3/ttfautohint-1.3.tar.gz"
  sha1 "5de45f0b5e3f87ad0a6b4153e5382765f17974ed"

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
    system "make install"
  end

  test do
    if build.with? "qt"
      system "#{bin}/ttfautohintGUI", "-V"
    else
      system "#{bin}/ttfautohint", "-V"
    end
  end
end
