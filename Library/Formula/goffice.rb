class Goffice < Formula
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.22.tar.xz"
  sha256 "0206a87a323b52a874dc54491374245f9e1c5f62e93a2ce4a02fb444a26b0e28"

  bottle do
    revision 1
    sha256 "943fbbb899e70e32713865fced621546cc91f071cf330ef77e9bb741c5eedb12" => :yosemite
    sha256 "8ba8d7c84c41f1bffde773a53eea635288a510de16cc58f8ec8bb45ec872e9b9" => :mavericks
    sha256 "47d932c8a2bb287cacdb28308b6d58dfc3cb00f5607e54c5538cd3c9aab8cbc3" => :mountain_lion
  end

  # Fixes a crash with quad precision math when building using clang
  # https://bugzilla.gnome.org/show_bug.cgi?id=749463
  patch :p0 do
    url "https://trac.macports.org/export/136404/trunk/dports/gnome/goffice/files/patch-goffice-math-go-quad.diff"
    sha256 "46989fd9a6088afdc5c4dcdfbef09cfaa956ed06ea98f13eca9bd1fe644a80b6"
  end

  head do
    url "https://github.com/GNOME/goffice.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "gdk-pixbuf"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pcre"
  depends_on :x11

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <goffice/goffice.h>
      int main()
      {
          void
          libgoffice_init (void);
          void
          libgoffice_shutdown (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgoffice-0.10",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["libgsf"].opt_include}/libgsf-1",
           "-I/usr/include/libxml2",
           "-I#{Formula["gtk+3"].opt_include}/gtk-3.0",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdk-pixbuf"].opt_include}/gdk-pixbuf-2.0",
           "-I#{Formula["atk"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
