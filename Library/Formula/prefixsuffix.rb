class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"

  bottle do
    sha256 "1143a29769e566e030bec8f3bf7a3f24a9c7fc69638511b6964571cc255b696f" => :el_capitan
    sha256 "544f17fbc8873abb8725d469f2cb076245d93527008f805f7b29416b6b20a82f" => :yosemite
    sha256 "eb984287bf98618cf61cf5e9ed85103077aaf4a36c8309fdcb6c9ecb736b4272" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtkmm3"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/prefixsuffix", "--version"
  end
end
