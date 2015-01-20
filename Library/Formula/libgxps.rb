class Libgxps < Formula
  homepage "https://live.gnome.org/libgxps"
  url "http://ftp.gnome.org/pub/gnome/sources/libgxps/0.2/libgxps-0.2.2.tar.xz"
  sha256 "39d104739bf0db43905c315de1d8002460f1a098576f4418f69294013a5820be"

  head do
    url "https://github.com/GNOME/libgxps.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libarchive"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "gtk+" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-man",
      "--prefix=#{prefix}",
    ]

    args << "--without-libjpeg" if build.without? "libjpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-liblcms2" if build.without? "lcms2"

    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system "#{bin}/xpstopdf", "--help"
  end
end
