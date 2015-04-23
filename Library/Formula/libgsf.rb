class Libgsf < Formula
  homepage "https://developer.gnome.org/gsf/"
  url "http://ftp.acc.umu.se/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.33.tar.xz"
  sha256 "82dd38e0c1f497704bf3b43682fca2768886058f004b14e9b5d103596f8c6e6b"

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  bottle do
    revision 1
    sha1 "f48d8c6bd40eee7b9be7c64e7ea21cb76285fcf3" => :yosemite
    sha1 "b7a8a49fba4d6d872441bba5e75d6ece2d37167d" => :mavericks
    sha1 "c6b181013b45e099918d9b2a84d24c963ce914cb" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gdk-pixbuf" => :optional
  depends_on "gettext"
  depends_on "glib"

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
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
