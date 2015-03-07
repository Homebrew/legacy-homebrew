class GtkDoc < Formula
  homepage "http://www.gtk.org/gtk-doc/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.21/gtk-doc-1.21.tar.xz"
  sha256 "5d934d012ee08edd1585544792efa80da271652587ba5b843d2cea8e8b80ee3e"

  bottle do
    sha1 "3499509d4916f5ec0eea321a5dc9f81d5dadb702" => :yosemite
    sha1 "1de0d6fc4ffdb851c8b61a4a32fee965b8f23293" => :mavericks
    sha1 "9a49cfeeeb239bab0be244871657fa3aba9a2f0a" => :mountain_lion
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
