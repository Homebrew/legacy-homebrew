require "formula"

class Links < Formula
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.8.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/links2/links2_2.8.orig.tar.bz2"
  sha1 "a808d80d910b7d3ad86f4c5089e64f35113b69f2"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :x11 => :optional
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--enable-graphics" if build.with? "x11"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libjpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/links", "https://duckduckgo.com"
  end
end
