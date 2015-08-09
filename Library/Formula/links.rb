class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.10.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/links2/links2_2.10.orig.tar.bz2"
  sha256 "840e0b0cc804a58567bdfed1fa8012c9ea2d34a853d4e90f857786ab4b791d53"

  bottle do
    cellar :any
    sha256 "ba2a8db08bc5a1bb6d500fce6d92b1ecdeff40eeef7688eda91960d9ef938b00" => :yosemite
    sha256 "b4a2fb839045ad5692b01a62fb32241e23cc7d714f296b2284909aa595467487" => :mavericks
    sha256 "9dc7d6d8f998d47cf172b1c6bf5bfe41133884ee553173b7c0b0d16bddd7a6a9" => :mountain_lion
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
