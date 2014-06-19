require "formula"

class TelepathyGabble < Formula
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-gabble/telepathy-gabble-0.18.3.tar.gz"
  sha1 "1c71c5acf2c506788aa4b1604390f38979d88887"

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "telepathy-glib"
  depends_on "openssl"
  depends_on "libsoup"
  depends_on "libnice"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-tests
      --disable-gtk-doc-html
      --disable-static
      --disable-dependency-tracking
      --with-tls=openssl
      --with-ca-certificates=#{etc}/openssl/cert.pem
    ]

    system "./configure", *args
    system "make install"
  end
end
