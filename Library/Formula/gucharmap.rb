class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/3.18/gucharmap-3.18.2.tar.xz"
  sha256 "80141d3e892c3c4812c1a8fad8f89978559ef19e933843267e6e9a5524c09ec9"

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
