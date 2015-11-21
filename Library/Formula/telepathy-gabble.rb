class TelepathyGabble < Formula
  desc "Telepathy Jabber/XMPP connection manager"
  homepage "https://wiki.freedesktop.org/telepathy/"
  url "git://anongit.freedesktop.org/telepathy/telepathy-gabble",
    :tag => "telepathy-gabble-0.99.11",
    :revision => "30cd70a45b6659ad9c571468ae6c49f38142dd5f"

  bottle do
    sha1 "39edf6b7b6392eb7ff400798bbb0d304114a55d5" => :mavericks
    sha1 "e1727fc04c0c2510f646b2c9ab947394cd730ee2" => :mountain_lion
    sha1 "1084ce8a5c9bf36c544bbe7105310d8410c38a37" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gtk-doc" => :build
  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "telepathy-glib"
  depends_on "openssl"
  depends_on "libsoup"
  depends_on "libnice"

  def install
    if MacOS.version >= :yosemite
      # Avoid a redefinition error on modern OS X versions
      inreplace "lib/ext/wocky/tests/wocky-test-sasl-auth-server.c" do |s|
        s.sub! "typedef int (*sasl_callback_ft)(void);", ""
      end
    end

    system "./autogen.sh", "--prefix=#{prefix}",
                           "--disable-debug",
                           "--disable-gtk-doc-html",
                           "--disable-static",
                           "--disable-dependency-tracking",
                           "--with-tls=openssl",
                           "--with-ca-certificates=#{etc}/openssl/cert.pem"
    system "make", "install"
  end
end
