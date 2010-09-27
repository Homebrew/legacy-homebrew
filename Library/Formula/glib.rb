require 'formula'

class Libiconv <Formula
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  md5 '7ab33ebd26687c744a37264a330bbe9a'
  homepage 'http://www.gnu.org/software/libiconv/'
end


class Glib <Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/glib/2.24/glib-2.24.2.tar.bz2'
  sha256 '3aeb521abd3642dd1224379f0e54915957e5010f888a4ae74afa0ad54da0160c'
  homepage 'http://www.gtk.org'

  depends_on 'pkg-config'
  depends_on 'gettext'

  def install
    fails_with_llvm "Undefined symbol errors while linking"

    # Snow Leopard libiconv doesn't have a 64bit version of the libiconv_open
    # function, which breaks things for us, so we build our own
    # http://www.mail-archive.com/gtk-list@gnome.org/msg28747.html

    iconvd = Pathname.getwd+'iconv'
    iconvd.mkpath

    Libiconv.new.brew do
      system "./configure", "--prefix=#{iconvd}", "--disable-debug", "--disable-dependency-tracking",
                            "--enable-static", "--disable-shared"
      system "make install"
    end

    # indeed, amazingly, -w causes gcc to emit spurious errors for this package!
    ENV.enable_warnings

    # basically we are going to statically link to the symbols that glib doesn't
    # find in the bugged GNU libiconv that ships with 10.6
    ENV['LDFLAGS'] += " #{iconvd}/lib/libiconv.a"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-rebuilds",
                          "--with-libiconv=gnu"
    system "make"
    ENV.j1 # Supress a folder already exists warning
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
