require 'formula'

class Libiconv < Formula
  homepage 'http://www.gnu.org/software/libiconv/'
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  md5 '7ab33ebd26687c744a37264a330bbe9a'
end

def build_tests?; ARGV.include? '--test'; end

class Glib < Formula
  homepage 'http://www.gtk.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/glib/2.28/glib-2.28.5.tar.bz2'
  sha256 '8eb4b56b228c6d0bf5021dd23db5b0084d80cc6d8d89d7863073c2da575ec22a'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  fails_with_llvm "Undefined symbol errors while linking"

  def patches
    mp = "http://trac.macports.org/export/77283/trunk/dports/devel/glib2/files/"
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
    [['--test', 'Build a debug build and run tests. NOTE: Tests may hang on "unix-streams".']]
  end

  def install
    # Snow Leopard libiconv doesn't have a 64bit version of the libiconv_open
    # function, which breaks things for us, so we build our own
    # http://www.mail-archive.com/gtk-list@gnome.org/msg28747.html

    iconvd = Pathname.getwd+'iconv'
    iconvd.mkpath

    Libiconv.new.brew do
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

    system "./configure", *args

    # Fix for 64-bit support, from MacPorts
    curl "http://trac.macports.org/export/69965/trunk/dports/devel/glib2/files/config.h.ed", "-O"
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
