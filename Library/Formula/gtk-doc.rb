require "formula"

class GtkDoc < Formula
  homepage "http://www.gtk.org/gtk-doc/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.20/gtk-doc-1.20.tar.xz"
  sha256 "3e6ecf134dbf92a74c24d79848fea3a48e59ab95408a38c6405905d95a293011"

  bottle do
    sha1 "be13f6a01fed97680dfce7c18704885d6cb7ed8f" => :mavericks
    sha1 "48b5f384aeebd39494794f46ed801f35f5bcfb6e" => :mountain_lion
    sha1 "0f88dda0c51d73acebc3b2ec1513f67ff7d5c87c" => :lion
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
    system "make install"
  end
end
