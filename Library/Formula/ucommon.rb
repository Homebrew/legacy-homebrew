require "formula"

class Ucommon < Formula
  homepage "https://www.gnu.org/software/commoncpp/"
  url "http://ftpmirror.gnu.org/commonc++/ucommon-6.2.2.tar.gz"
  sha1 "867e06988de3dea1d04a71155bf77063df6fcd8f"

  bottle do
    sha1 "4fc88a216680dde8e5aa696a8839beaa0fb37231" => :yosemite
    sha1 "599bda579daf84ad9975a0c7c96f406c716f17dd" => :mavericks
    sha1 "1001ef2f9cf1fc1d4d982a6a03dd2a70f3754126" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    # Replace the ldd with OS X's otool. This is unlikely to be merged upstream.
    # Emailed upstream (dyfet at gnu dot org) querying this on 25/11/14.
    # It generates a very minor runtime error without the inreplace, so...
    inreplace "commoncpp-config.in", "ldd /bin/sh", "otool -L /bin/sh"
    inreplace "ucommon-config.in", "ldd /bin/sh", "otool -L /bin/sh"

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--enable-socks",
                          "--with-sslstack=gnutls", "--with-pkg-config"
    system "make", "install"
  end

  test do
    system "#{bin}/ucommon-config", "--libs"
  end
end
