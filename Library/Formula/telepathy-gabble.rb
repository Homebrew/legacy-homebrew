class TelepathyGabble < Formula
  desc "Telepathy Jabber/XMPP connection manager"
  homepage "https://wiki.freedesktop.org/telepathy/"
  url "git://anongit.freedesktop.org/telepathy/telepathy-gabble",
    :tag => "telepathy-gabble-0.99.11",
    :revision => "30cd70a45b6659ad9c571468ae6c49f38142dd5f"

  bottle do
    sha256 "2095502b671631f5d1d466c2b67d52ba055dd985bcb8c56ee659c57c31f67244" => :el_capitan
    sha256 "3cf49e282137f0fd64c5f966407613252b2908fec66d972ac5acffbc13f56791" => :yosemite
    sha256 "cf516a9606026697e4c1cf64f4dbbe02be5dc82efad2ba7343b2b347866f1fb6" => :mavericks
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
