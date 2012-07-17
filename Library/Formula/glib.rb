require 'formula'

def build_tests?; ARGV.include? '--test'; end

class Glib < Formula
  homepage 'http://developer.gnome.org/glib/'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/glib/2.32/glib-2.32.4.tar.xz'
  sha256 'a5d742a4fda22fb6975a8c0cfcd2499dd1c809b8afd4ef709bda4d11b167fae2'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'libffi'

  fails_with :llvm do
    build 2334
    cause "Undefined symbol errors while linking"
  end

  def patches
    # https://bugzilla.gnome.org/show_bug.cgi?id=673047  Still open at 2.32.3
    # https://bugzilla.gnome.org/show_bug.cgi?id=644473  Still open at 2.32.3
    # https://bugzilla.gnome.org/show_bug.cgi?id=673135  Resolved as wontfix.
    p = { :p1 => %W[
        https://raw.github.com/gist/2235195/19cdaebdff7dcc94ccd9b3747d43a09318f0b846/glib-gunicollate.diff
        https://raw.github.com/gist/2235202/26f885e079e4d61da26d239970301b818ddbb4ab/glib-gtimezone.diff
        https://raw.github.com/gist/2246469/591586214960f7647b1454e7d547c3935988a0a7/glib-configurable-paths.diff
      ]}
    p[:p0] = %W[
        https://trac.macports.org/export/95596/trunk/dports/devel/glib2/files/patch-configure.diff
      ] if ARGV.build_universal?
    p
  end

  def options
  [
    ['--universal', 'Build universal binaries.'],
    ['--test', 'Build a debug build and run tests. NOTE: Not all tests succeed yet.']
  ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    # -w is said to causes gcc to emit spurious errors for this package
    ENV.enable_warnings if ENV.compiler == :gcc

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    args = %W[
      --disable-maintainer-mode
      --disable-dependency-tracking
      --disable-dtrace
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    system "./configure", *args

    if ARGV.build_universal?
      system "curl 'https://trac.macports.org/export/95596/trunk/dports/devel/glib2/files/config.h.ed' | ed - config.h"
    end

    system "make"
    # the spawn-multithreaded tests require more open files
    system "ulimit -n 1024; make check" if build_tests?
    system "make install"

    # This sucks; gettext is Keg only to prevent conflicts with the wider
    # system, but pkg-config or glib is not smart enough to have determined
    # that libintl.dylib isn't in the DYLIB_PATH so we have to add it
    # manually.
    gettext = Formula.factory('gettext')
    inreplace lib+'pkgconfig/glib-2.0.pc' do |s|
      s.gsub! 'Libs: -L${libdir} -lglib-2.0 -lintl',
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext.lib} -lintl"

      s.gsub! 'Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include',
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext.include}"
    end

    (share+'gtk-doc').rmtree
  end

  def test
    unless Formula.factory("pkg-config").installed?
      puts "pkg-config is required to run this test, but is not installed"
      exit 1
    end

    mktemp do
      (Pathname.pwd/'test.c').write <<-EOS.undent
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
      system ENV.cc, "-o", "test", "test.c",
        *`pkg-config --cflags --libs glib-2.0`.split
      system "./test"
    end
  end
end
