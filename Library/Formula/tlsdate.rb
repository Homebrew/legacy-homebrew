class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.13.tar.gz"
  sha256 "90efdff87504b5159cb6a3eefa9ddd43723c073d49c4b3febba9e48fc1292bf9"
  head "https://github.com/ioerror/tlsdate.git"

  bottle do
    sha256 "c7d7ea17bf9e7cb9b897a0f0aeed0ef3c50f2c309e0b6055fdfe7bee3aca5152" => :el_capitan
    sha256 "58bfadb241575316ab6877c584a09e3681084165bfd733430e5c3f4b0b8be494" => :yosemite
    sha256 "cf446ccff505ef69dd583f61d82a61420697b39c66c2cd2f006944d688ac8fee" => :mavericks
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
