class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.10.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/links2/links2_2.10.orig.tar.bz2"
  sha256 "840e0b0cc804a58567bdfed1fa8012c9ea2d34a853d4e90f857786ab4b791d53"

  bottle do
    cellar :any
    sha256 "9c468f11a9e9ff9d92d3f0b2bfab3f5e4f5443452a29cfe12430a698f09eadb1" => :yosemite
    sha256 "dc5de25fd445197c5b9178cb1c58cbe569dcba88917d7a4e71415bb3a8693897" => :mavericks
    sha256 "85bb5d8f897dc4115c969a47c5b4062ade14f975c65967956bde35f52693ecff" => :mountain_lion
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
