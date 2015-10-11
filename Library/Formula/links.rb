class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  # Switch url & mirror back over when twibright is responsive.
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/links2/links2_2.12.orig.tar.bz2"
  mirror "http://links.twibright.com/download/links-2.12.tar.bz2"
  sha256 "98411811ded1e8028f5aed708dd7d8ec0ae63ce24c2991a0241a989b7d09d84e"

  bottle do
    cellar :any
    sha256 "67692ebeb7ebb67762edfdadc9be95b0e377bb8fefb953ee5fb1ac78b3b67afe" => :el_capitan
    sha256 "d50d0e0eeffb7dbddc34b4533d2ab6f176de31bf9879b25dfea361dfca23e7c3" => :yosemite
    sha256 "fd396fed5e0d5c9a43da779fc8ed57ca68c9af02ddaa9d14b46d3a0402bdaf25" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional
  depends_on "librsvg" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    if build.with? "libressl"
      args << "--with-ssl=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    end

    args << "--enable-graphics" if build.with? "x11"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-librsvg" if build.without? "librsvg"

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
