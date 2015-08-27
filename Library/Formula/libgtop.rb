class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.28/libgtop-2.28.5.tar.xz"
  sha256 "c812c174e44a8971a1f33265437cfd10f1e99869c7f5c05f8ee95846a70a3342"

  bottle do
    revision 1
    sha1 "b6762fe85c8fdbf57c6530261a49e78c37b1a9ee" => :yosemite
    sha1 "91085d6ace20d9ad4f79a9bf296a10027fd3a8d2" => :mavericks
    sha1 "52f47e23108f5530f53dacfcaf01e3e78cb05d3f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end
end
