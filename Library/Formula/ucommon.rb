class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "http://ftpmirror.gnu.org/commonc++/ucommon-6.2.2.tar.gz"
  sha256 "1ddcef26dc5c930225de6ab9adc3c389cb3f585eba0b0f164206f89d2dafea66"
  revision 1

  bottle do
    sha256 "eea46c279fd145ec3d8a7a3d9b751465341e8f69aa507bd6f7025d9437019b0c" => :el_capitan
    sha256 "6237fa697417c4defdfc513c7b56e93ce7156b5b38a4164e7a27c9e285688c0a" => :yosemite
    sha256 "6fe4b60fa239460cf900a9660ab08275865d167c0811e3f8069307c19b2b8060" => :mavericks
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
