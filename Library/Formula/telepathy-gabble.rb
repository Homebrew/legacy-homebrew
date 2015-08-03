class TelepathyGabble < Formula
  desc "Telepathy Jabber/XMPP connection manager"
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-gabble/telepathy-gabble-0.18.3.tar.gz"
  sha256 "8ec714607e9bcb8d5a3f44adf871e7b07d5db8e326e47536e74e09cba59989c2"
  revision 1

  bottle do
    sha1 "39edf6b7b6392eb7ff400798bbb0d304114a55d5" => :mavericks
    sha1 "e1727fc04c0c2510f646b2c9ab947394cd730ee2" => :mountain_lion
    sha1 "1084ce8a5c9bf36c544bbe7105310d8410c38a37" => :lion
  end

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
    system "make", "install"
  end
end
