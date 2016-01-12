class Libnotify < Formula
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.6.tar.xz"
  sha256 "0ef61ca400d30e28217979bfa0e73a7406b19c32dd76150654ec5b2bdf47d837"

  depends_on "pkg-config" => :build
  depends_on "gtk+3" => :build
  depends_on "gdk-pixbuf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
