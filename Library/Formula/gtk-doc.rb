class GtkDoc < Formula
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.23/gtk-doc-1.23.tar.xz"
  sha256 "0b5c23711166c10ff5c74603db80ac26c2b9a382ce778b0e795db821d50718c4"

  bottle do
    sha256 "941b07e4d71fd9d618dd5fb2ad843f6878174c8edefb51188a01a93aab8d6fde" => :yosemite
    sha256 "d76105eb7f2ede31416bd558efb8bfcfe9854e2952a0f0c8c8b90f00d05d1ef0" => :mavericks
    sha256 "b7d157aea788de01e9943b255b4769ea936d0c0eb29d53f5a1033cf31b5d5522" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnome-doc-utils" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2" => "with-python"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gtkdoc-scan", "--module=test"
    system "#{bin}/gtkdoc-mkdb", "--module=test"
  end
end
