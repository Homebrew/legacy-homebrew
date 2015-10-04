class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  # Switch url & mirror back over when twibright is responsive.
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/links2/links2_2.12.orig.tar.bz2"
  mirror "http://links.twibright.com/download/links-2.12.tar.bz2"
  sha256 "98411811ded1e8028f5aed708dd7d8ec0ae63ce24c2991a0241a989b7d09d84e"

  bottle do
    cellar :any
    sha256 "8779e7a0cf9424c4115ca1fcc7ebc894e576cee06ce16be100dcfbd7e9a496bf" => :el_capitan
    sha256 "3fb2262ebfabe71227d8bc1ccaa13e54e4b44b85792b7720874c27a0975cf6de" => :yosemite
    sha256 "c02773c8a66a69990669d35e712852db52c8f64a3f801af9e10222d811351869" => :mavericks
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
