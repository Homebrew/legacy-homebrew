class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "http://ftpmirror.gnu.org/commonc++/ucommon-6.2.2.tar.gz"
  sha256 "1ddcef26dc5c930225de6ab9adc3c389cb3f585eba0b0f164206f89d2dafea66"
  revision 1

  bottle do
    sha256 "f824dc6564e718d4c087035dfafe0ff8bceeb6c863fd51b27b088d6a173d1952" => :yosemite
    sha256 "b553cd16fcf4cf682984f21f27dccebf55ea3f10a5c991be1792fae1d465f795" => :mavericks
    sha256 "fc3e384c3e0e3599fde0d6d1b5cee4a74a4f0d4c83dd41913a02b02cd5f643f0" => :mountain_lion
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
