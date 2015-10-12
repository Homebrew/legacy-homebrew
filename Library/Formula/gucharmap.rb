class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/3.18/gucharmap-3.18.1.tar.xz"
  sha256 "b286d09dcd7811e6678e3d5830970d310d5730f7be5657ec400295df0b36fa35"

  bottle do
    sha256 "95ce4bd070880a587377c8ce44e640e261cebe62ac52e99efba74e1dfa6aaf83" => :el_capitan
    sha256 "4e668344c5234763f9faf44cf1205c835cf0826034c20de4d97aec0d5ac2bece" => :yosemite
    sha256 "ba6aecfbea1860e734b6eaaf0f52823fb9611af8458652bbabb994564101b3ec" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "gtk+3"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no"
    system "make"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
