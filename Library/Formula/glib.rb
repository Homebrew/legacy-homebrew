require 'formula'

def build_tests?; ARGV.include? '--test'; end

class Glib < Formula
  homepage 'http://developer.gnome.org/glib/'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/glib/2.30/glib-2.30.3.tar.xz'
  sha256 'e6cbb27c71c445993346e785e8609cc75cea2941e32312e544872feba572dd27'

  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'libffi'

  fails_with_llvm "Undefined symbol errors while linking", :build => 2334

  def patches
    { :p0 => %W[
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-configure.diff
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-glib-2.0.pc.in.diff
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-glib_gunicollate.c.diff
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-gi18n.h.diff
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-gio_xdgmime_xdgmime.c.diff
      https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/patch-gio_gdbusprivate.c.diff
      ]}
  end

  def options
  [
    ['--universal', 'Build universal binaries.'],
    ['--test', 'Build a debug build and run tests. NOTE: Tests may hang on "unix-streams".']
  ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    # indeed, amazingly, -w causes gcc to emit spurious errors for this package!
    ENV.enable_warnings

    args = ["--disable-dependency-tracking", "--disable-rebuilds",
            "--prefix=#{prefix}",
            "--disable-dtrace"]

    args << "--disable-debug" unless build_tests?

    # MacPorts puts "@@PREFIX@@" in patches and does inreplace on the files,
    # so we must follow suit if we use their patches
    inreplace ['gio/xdgmime/xdgmime.c', 'gio/gdbusprivate.c'] do |s|
      s.gsub! '@@PREFIX@@', HOMEBREW_PREFIX
    end

    # glib and pkg-config <= 0.26 have circular dependencies, so we should build glib without pkg-config
    # The pkg-config dependency can be eliminated if certain env variables are set
    # Note that this *may* need to be updated if any new dependencies are added in the future
    # See http://permalink.gmane.org/gmane.comp.package-management.pkg-config/627
    ENV['ZLIB_CFLAGS'] = ''
    ENV['ZLIB_LIBS'] = '-lz'
    # libffi include paths are dramatically ugly
    libffi = Formula.factory('libffi')
    ENV['LIBFFI_CFLAGS'] = "-I #{libffi.lib}/libffi-#{libffi.version}/include"
    ENV['LIBFFI_LIBS'] = '-lffi'

    system "./configure", *args

    # Fix for 64-bit support, from MacPorts
    curl "https://trac.macports.org/export/87537/trunk/dports/devel/glib2/files/config.h.ed", "-O"
    system "ed - config.h < config.h.ed"

    system "make"
    # Suppress a folder already exists warning during install
    # Also needed for running tests
    ENV.j1
    system "make test" if build_tests?
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
