class Geoclue2 < Formula
  homepage "http://www.freedesktop.org/wiki/Software/GeoClue/"
  url "http://www.freedesktop.org/software/geoclue/releases/2.1/geoclue-2.1.10.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/geoclue-2.0/geoclue-2.0_2.1.10.orig.tar.xz"
  sha1 "84cde181d17d58a52f6ac2d218b59c106f675fb0"

  head do
    url "http://anongit.freedesktop.org/git/geoclue.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnome-common" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libsoup"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}", "--disable-silent-rules",
                          "--disable-dependency-tracking","--disable-3g-source", "--disable-cdma-source",
                          "--disable-modem-gps-source", "--localstatedir=#{var}"
    system "make", "install"
  end
end
