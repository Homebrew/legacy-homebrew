class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "http://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.5/ttfautohint-1.5.tar.gz"
  sha256 "644fe721e9e7fe3390ae1f66d40c74e4459fa539d436f4e0f8635c432683efd1"

  bottle do
    cellar :any
    sha256 "18fe5769eed8332423805f93571e8b7dbdc26a7b51d1912aec2b3d76d40f59b5" => :el_capitan
    sha256 "ae60250c59eb3751cc7e2c76ab319c5bef81d916bf4a81fb2428b7547177513f" => :yosemite
    sha256 "8184c3cbfbae95edd6ff56edeb0a76f2ddc3eeef38093fb9a83a39a944307359" => :mavericks
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
