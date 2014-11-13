require 'formula'

class Glib < Formula
  homepage "http://developer.gnome.org/glib/"
  url "http://ftp.gnome.org/pub/gnome/sources/glib/2.42/glib-2.42.0.tar.xz"
  sha256 "94fbc0a7d10633433ff383e540607de649c1b46baaa59dea446a50977a6c4472"

  bottle do
    sha1 "c85b04f9c53b61c72b52a94ed3859515b3b812fc" => :yosemite
    sha1 "37c62e46737afec92ee03da87f34f6b1aae9d9c9" => :mavericks
    sha1 "82cfc3ca5c9d4af16f8780c554b7da0929d50187" => :mountain_lion
    sha1 "7cbe73aa32f468f3ef0725d55aaa0b04d257daea" => :lion
  end

  option :universal
  option 'test', 'Build a debug build and run tests. NOTE: Not all tests succeed yet'
  option 'with-static', 'Build glib with a static archive.'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'libffi'

  fails_with :llvm do
    build 2334
    cause "Undefined symbol errors while linking"
  end

  resource 'config.h.ed' do
    url 'https://trac.macports.org/export/111532/trunk/dports/devel/glib2/files/config.h.ed'
    version '111532'
    sha1 '0926f19d62769dfd3ff91a80ade5eff2c668ec54'
  end

  # https://bugzilla.gnome.org/show_bug.cgi?id=673135 Resolved as wontfix,
  # but needed to fix an assumption about the location of the d-bus machine
  # id file.
  patch do
    url "https://gist.githubusercontent.com/jacknagel/af332f42fae80c570a77/raw/7b5fd0d2e6554e9b770729fddacaa2d648327644/glib-hardcoded-paths.diff"
    sha1 "78bbc0c7349d7bfd6ab1bfeabfff27a5dfb1825a"
  end

  # Fixes compilation with FSF GCC. Doesn't fix it on every platform, due
  # to unrelated issues in GCC, but improves the situation.
  # Patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=672777
  patch do
    url "https://gist.githubusercontent.com/jacknagel/9835034/raw/371fd57f7d3823c67dbd5bc738df7ef5ffc7545f/gio.patch"
    sha1 "b947912a4f59630c13e53056c8b18bde824860f4"
  end

  patch do
    url "https://gist.githubusercontent.com/jacknagel/9726139/raw/bc60b41fa23ae72f56128e16c9aa5d2d26c75c11/universal.patch"
    sha1 "ab9b8ba9d7c3fd493a0e24638a95e26f3fe613ac"
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

    args << '--enable-static' if build.with? 'static'

    system "./configure", *args

    if build.universal?
      buildpath.install resource('config.h.ed')
      system "ed -s - config.h <config.h.ed"
    end

    system "make"
    # the spawn-multithreaded tests require more open files
    system "ulimit -n 1024; make check" if build.include? 'test'
    system "make install"

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"].opt_prefix
    inreplace lib+'pkgconfig/glib-2.0.pc' do |s|
      s.gsub! 'Libs: -L${libdir} -lglib-2.0 -lintl',
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
      s.gsub! 'Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include',
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
    end

    (share+'gtk-doc').rmtree
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
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
