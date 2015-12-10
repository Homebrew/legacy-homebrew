class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.13.tar.gz"
  sha256 "90efdff87504b5159cb6a3eefa9ddd43723c073d49c4b3febba9e48fc1292bf9"
  head "https://github.com/ioerror/tlsdate.git"

  bottle do
    sha256 "3cccdaaa4afef83888242af97c7d114c98bc0729abefc1f4f520c962be87db33" => :el_capitan
    sha256 "c904319078859012e71d74349fa5af1807bfa7ca2d768f3cc369c70d2ecefaa7" => :yosemite
    sha256 "7029cf53f6f9f1c6a7bd00a4a8e846bc9b0d3f18bbc86b147f03ef3814f324d1" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :build
  depends_on "openssl"

  # Upstream PR to fix the build on OS X
  patch do
    url "https://github.com/ioerror/tlsdate/pull/160.patch"
    sha256 "78a739d952d2fa0046eec958194136c50751c0e97bfe9f5ed173ecc864f8adb8"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tlsdate", "--verbose", "--dont-set-clock"
  end
end
