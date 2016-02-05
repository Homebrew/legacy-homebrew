class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.3.2.tar.gz"
  sha256 "24f22378ffce6bd6e7e5ec69d44f3139ee102b1af59c39cddb5e6eadaf2484f8"

  bottle do
    cellar :any
    sha256 "583d77b3795c803258649d42dcad161587dfd4619c57e69e4a09a0b16289d612" => :el_capitan
    sha256 "b520acd2e6169ca96a5a00214908b819f0a4ad3ecb109dc4bcac7567dbd0747b" => :yosemite
    sha256 "409ae0e5fea5a7e9534a914c3eb9eca48198892d100818e913c5f5868f507fff" => :mavericks
    sha256 "d9a294e36d238945e881f75f33d07e93f77370e0902a0de5591aeb4d482f28f1" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :recommended
  depends_on "libxml2"
  depends_on "openssl"

  def install
    system "autoreconf -i"
    system "automake"
    system "autoconf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end
