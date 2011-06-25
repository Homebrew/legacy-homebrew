require 'formula'

class Libiconv < Formula
  homepage 'http://www.gnu.org/software/libiconv/'
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  md5 '7ab33ebd26687c744a37264a330bbe9a'
end

def build_tests?; ARGV.include? '--test'; end

class Glib < Formula
  homepage 'http://developer.gnome.org/glib/2.28/'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/glib/2.28/glib-2.28.7.tar.bz2'
  sha256 '0e1b3816a8934371d4ea2313dfbe25d10d16c950f8d02e0a7879ae10d91b1631'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  fails_with_llvm "Undefined symbol errors while linking"

  def patches
    mp = "https://svn.macports.org/repository/macports/trunk/dports/devel/glib2/files/"
    {
      :p0 => [
        mp+"patch-configure.ac.diff",
        mp+"patch-glib-2.0.pc.in.diff",
        mp+"patch-glib_gunicollate.c.diff",
        mp+"patch-gi18n.h.diff",
        mp+"patch-gio_xdgmime_xdgmime.c.diff",
        mp+"patch-gio_gdbusprivate.c.diff"
      ]
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

    # Snow Leopard libiconv doesn't have a 64bit version of the libiconv_open
    # function, which breaks things for us, so we build our own
    # http://www.mail-archive.com/gtk-list@gnome.org/msg28747.html

    iconvd = Pathname.getwd+'iconv'
    iconvd.mkpath

    Libiconv.new.brew do
      # Help out universal builds
      # TODO - do these lines need to be here?
      # ENV["ac_cv_func_malloc_0_nonnull"]='yes'
      # ENV["gl_cv_func_malloc_0_nonnull"]='1'

      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{iconvd}",
                            "--enable-static", "--disable-shared"
      system "make install"
    end

    # indeed, amazingly, -w causes gcc to emit spurious errors for this package!
    ENV.enable_warnings

    # Statically link to libiconv so glib doesn't use the bugged version in 10.6
    ENV['LDFLAGS'] += " #{iconvd}/lib/libiconv.a"

    args = ["--disable-dependency-tracking", "--disable-rebuilds",
            "--prefix=#{prefix}",
            "--with-libiconv=gnu"]

    args << "--disable-debug" unless build_tests?

    if ARGV.build_universal?
      # autoconf 2.61 is fine don't worry about it
      inreplace ["aclocal.m4", "configure.ac"] do |s|
        s.gsub! "AC_PREREQ([2.62])", "AC_PREREQ([2.61])"
      end

      # Run autoconf so universal builds will work
      system "autoconf"
    end

    system "./configure", *args

    # Fix for 64-bit support, from MacPorts
    curl "https://svn.macports.org/repository/macports/trunk/dports/devel/glib2/files/config.h.ed", "-O"
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
