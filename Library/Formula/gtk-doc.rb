class GtkDoc < Formula
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.24/gtk-doc-1.24.tar.xz"
  sha256 "b420759ea05c760301bada14e428f1b321f5312f44e10a176d6804822dabb58b"

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
