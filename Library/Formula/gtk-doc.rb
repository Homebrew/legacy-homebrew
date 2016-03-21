class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz"
  sha256 "1ea46ed400e6501f975acaafea31479cea8f32f911dca4dff036f59e6464fd42"

  bottle do
    sha256 "7467edb24beda3fda8082721f96f3198c3165f1fc3c129a01d0f36b3e5518e8f" => :yosemite
    sha256 "4b19d896364a304180cbf12a9df44fa00192774ab48f2020024eff962c2c2745" => :mavericks
    sha256 "896f095dec0e72eba5c15ad962167febc56439c7152aa2951f0634acddaef0a7" => :mountain_lion
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
