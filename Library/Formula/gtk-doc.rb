class GtkDoc < Formula
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.22/gtk-doc-1.22.tar.xz"
  sha256 "932865c912ce0d81c9480bf957d3908bae6e18c0cf2ee33014d63b920047fca8"

  bottle do
    sha256 "654ae76d5e15f8461dbfd0be4ed8c52d67e7cc2dd4e8f4fc893fc9e5feedcd2f" => :yosemite
    sha256 "2b617b6fe81f7cb8fdc7252208552879ba1af12a892e0abfdd70863e455d4a48" => :mavericks
    sha256 "ec163f5b3edbfab4b35c5e213d66fe4f7b4f63130a64cc3ec635e3369ca12e79" => :mountain_lion
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
