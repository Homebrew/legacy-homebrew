class Links < Formula
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.9.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/links2/links2_2.9.orig.tar.bz2"
  sha256 "4360ead54d5f41da16b2f4c0033317ca775f40c1e658a29e9e7f8ce4bc23878f"

  bottle do
    cellar :any
    sha1 "e59741a8ae32d09d3b621169095eb871d62af2c3" => :mavericks
    sha1 "5040c93b09ec5b2ba02e80ff4283d974b5f12d64" => :mountain_lion
    sha1 "c1a7f7f4b11ed3907eadcd1d66b633f94e89ac9d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional
  depends_on :x11 => :optional

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
    system bin/"links", "https://duckduckgo.com"
  end
end
