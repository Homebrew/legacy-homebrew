require 'formula'

def build_tests?; ARGV.include? '--test'; end

class Glib < Formula
  homepage 'http://developer.gnome.org/glib/'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/glib/2.30/glib-2.30.2.tar.bz2'
  sha256 '94b1f1a1456c67060ca868d299bef3f7268a2c1c5c360aabb7149d4d9b2fdcd3'

  depends_on 'gettext'
  depends_on 'libffi'

  fails_with_llvm "Undefined symbol errors while linking", :build => 2334

  def patches
    mp = "https://svn.macports.org/repository/macports/!svn/bc/87537/trunk/dports/devel/glib2/files/"
    {
      :p0 => [
        mp+"patch-configure.diff",
        mp+"patch-glib-2.0.pc.in.diff",
        mp+"patch-glib_gunicollate.c.diff",
        mp+"patch-gi18n.h.diff",
        mp+"patch-gio_xdgmime_xdgmime.c.diff",
        mp+"patch-gio_gdbusprivate.c.diff"
      ],
      :p1 => [ DATA ]
    }
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

    if ARGV.build_universal?
      # autoconf 2.61 is fine don't worry about it
      inreplace ["aclocal.m4", "configure.ac"] do |s|
        s.gsub! "AC_PREREQ([2.62])", "AC_PREREQ([2.61])"
      end

      # Run autoconf so universal builds will work
      system "autoconf"
    end

    # glib and pkg-config <= 0.26 have circular dependencies, so we should build glib without pkg-config
    # The pkg-config dependency can be eliminated if certain env variables are set
    # Note that this *may* need to be updated if any new dependencies are added in the future
    # See http://permalink.gmane.org/gmane.comp.package-management.pkg-config/627
    ENV['ZLIB_CFLAGS'] = ''
    ENV['ZLIB_LIBZ'] = '-l'
    # libffi include paths are dramatically ugly
    libffi = Formula.factory('libffi')
    ENV['LIBFFI_CFLAGS'] = "-I #{libffi.lib}/libffi-#{libffi.version}/include"
    ENV['LIBFFI_LIBS'] = '-lffi'

    system "./configure", *args

    # Fix for 64-bit support, from MacPorts
    curl "https://svn.macports.org/repository/macports/!svn/bc/87537/trunk/dports/devel/glib2/files/config.h.ed", "-O"
    system "ed - config.h < config.h.ed"

    system "make"
    # Supress a folder already exists warning during install
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
end

# glib is being overzealous about trying to detect situations where you use headers from one version
# of iconv with libraries from another. The libiconv that comes with OS X is actually GNU libiconv,
# but symbols have standard name like iconv_open instead of libiconv_open, and glib gets a bit
# confused. This patch solves the problem by disabling glib's faulty check.
# Bug filed with upstream at https://bugzilla.gnome.org/show_bug.cgi?id=665705
__END__
diff --git a/glib/gconvert.c b/glib/gconvert.c
index b363bca..9924c6c 100644
--- a/glib/gconvert.c
+++ b/glib/gconvert.c
@@ -62,7 +62,6 @@
 #error GNU libiconv in use but included iconv.h not from libiconv
 #endif
 #if !defined(USE_LIBICONV_GNU) && defined (_LIBICONV_H)
-#error GNU libiconv not in use but included iconv.h is from libiconv
 #endif
