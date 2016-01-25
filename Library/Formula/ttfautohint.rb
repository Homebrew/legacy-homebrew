class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.5/ttfautohint-1.5.tar.gz"
  sha256 "644fe721e9e7fe3390ae1f66d40c74e4459fa539d436f4e0f8635c432683efd1"

  bottle do
    cellar :any
    sha256 "4bb7c539560829509ee88e8da9b96ca1fec5f3089fd9ffca792ae77e15e75d1d" => :el_capitan
    sha256 "998e9107b1a6fa606d9247e92f721e5a7f96217fd6cd91fab7e90f5eb03b3b2a" => :yosemite
    sha256 "63e69aaf897ba65b1427c99f7ccf1a2eb1d0a03ebe35f3a0a392a33aec9dbd5e" => :mavericks
  end

  head do
    url "http://repo.or.cz/ttfautohint.git"
    depends_on "bison" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "libtool" => :build
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
