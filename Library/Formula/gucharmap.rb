class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/3.18/gucharmap-3.18.1.tar.xz"
  sha256 "b286d09dcd7811e6678e3d5830970d310d5730f7be5657ec400295df0b36fa35"

  bottle do
    sha256 "bdecad9b6458edd762e245d2b40d4d1b4c789b06f9bf6a55c36cbe5d7018e206" => :el_capitan
    sha256 "66855710a2c4c2ca307011f50ac5a65f4697037631b236bc68df8b1cf0e47b21" => :yosemite
    sha256 "7e5e4435abc1aa57f7cef504d10def6a045a4858db3088717cc698aba9d7a9d2" => :mavericks
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
