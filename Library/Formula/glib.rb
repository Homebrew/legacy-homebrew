class Glib < Formula
  homepage "https://developer.gnome.org/glib/"
  url "http://ftp.gnome.org/pub/gnome/sources/glib/2.44/glib-2.44.0.tar.xz"
  sha256 "f2d362b106a08fa801770d41829a06fcfe287a00421018869eebf5efc796f5b9"

  bottle do
    sha256 "d520b2a66d30980984e941da1c527d161188e347eb684eff5c93f465925818ee" => :yosemite
    sha256 "5fe51191fbdedebdbb37738cd8e10ee4069fff832359b2ce446656759a56a4e3" => :mavericks
    sha256 "0e44ed5114c08b165081e0338d6ccbda8023f0839b57e978bebfd408776b1ae6" => :mountain_lion
  end

  option :universal
  option "with-test", "Build a debug build and run tests. NOTE: Not all tests succeed yet"
  option "with-static", "Build glib with a static archive."

  deprecated_option "test" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libffi"

  fails_with :llvm do
    build 2334
    cause "Undefined symbol errors while linking"
  end

  resource "config.h.ed" do
    url "https://trac.macports.org/export/111532/trunk/dports/devel/glib2/files/config.h.ed"
    version "111532"
    sha256 "9f1e23a084bc879880e589893c17f01a2f561e20835d6a6f08fcc1dad62388f1"
  end

  # https://bugzilla.gnome.org/show_bug.cgi?id=673135 Resolved as wontfix,
  # but needed to fix an assumption about the location of the d-bus machine
  # id file.
  patch do
    url "https://gist.githubusercontent.com/jacknagel/af332f42fae80c570a77/raw/7b5fd0d2e6554e9b770729fddacaa2d648327644/glib-hardcoded-paths.diff"
    sha256 "a4cb96b5861672ec0750cb30ecebe1d417d38052cac12fbb8a77dbf04a886fcb"
  end

  # Fixes compilation with FSF GCC. Doesn't fix it on every platform, due
  # to unrelated issues in GCC, but improves the situation.
  # Patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=672777
  patch do
    url "https://gist.githubusercontent.com/jacknagel/9835034/raw/282d36efc126272f3e73206c9865013f52d67cd8/gio.patch"
    sha256 "d285c70cfd3434394a1c77c92a8d2bad540c954aad21e8bb83777482c26aab9a"
  end

  patch do
    url "https://gist.githubusercontent.com/jacknagel/9726139/raw/a351ea240dea33b15e616d384be0550f5051e959/universal.patch"
    sha256 "7e1ad7667c7d89fcd08950c9c32cd66eb9c8e2ee843f023d1fadf09a9ba39fee"
  end if build.universal?

  def install
    ENV.universal_binary if build.universal?

    inreplace %w[gio/gdbusprivate.c gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    args = %W[
      --disable-maintainer-mode
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-dtrace
      --disable-libelf
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-gio-module-dir=#{HOMEBREW_PREFIX}/lib/gio/modules
    ]

    args << "--enable-static" if build.with? "static"

    system "./configure", *args

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    system "make"
    # the spawn-multithreaded tests require more open files
    system "ulimit -n 1024; make check" if build.with? "test"
    system "make", "install"

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"].opt_prefix
    inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
    end

    (share+"gtk-doc").rmtree
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
      EOS
    flags = ["-I#{include}/glib-2.0", "-I#{lib}/glib-2.0/include", "-lglib-2.0"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
