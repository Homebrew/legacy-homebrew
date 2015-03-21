class Gexiv2 < Formula
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.2.tar.xz"
  sha256 "2fd21f0ed5125e51d02226e7f41be751cfa8ae411a8ed1a651e16b06d79047b2"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "exiv2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
