class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.9.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/links2/links2_2.9.orig.tar.bz2"
  sha256 "4360ead54d5f41da16b2f4c0033317ca775f40c1e658a29e9e7f8ce4bc23878f"

  bottle do
    cellar :any
    sha256 "ba2a8db08bc5a1bb6d500fce6d92b1ecdeff40eeef7688eda91960d9ef938b00" => :yosemite
    sha256 "b4a2fb839045ad5692b01a62fb32241e23cc7d714f296b2284909aa595467487" => :mavericks
    sha256 "9dc7d6d8f998d47cf172b1c6bf5bfe41133884ee553173b7c0b0d16bddd7a6a9" => :mountain_lion
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
