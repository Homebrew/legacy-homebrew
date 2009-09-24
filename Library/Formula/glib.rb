require 'brewkit'

class Libiconv <Formula
  @url='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  @homepage='http://www.gnu.org/software/libiconv/'
  @md5='7ab33ebd26687c744a37264a330bbe9a'
end


class Glib <Formula
  @url='http://ftp.acc.umu.se/pub/gnome/sources/glib/2.20/glib-2.20.5.tar.bz2'
  @md5='4c178b91d82ef80a2da3c26b772569c0'
  @homepage='http://www.gtk.org'

  depends_on 'pkg-config'
  depends_on 'gettext'

  def install
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
    system "make install"

    # this sucks, basically gettext is Keg only to prevent conflicts with
    # the wider system, but pkg-config or glib is not smart enough to
    # have determined that libintl.dylib isn't in the DYLIB_PATH so we have
    # to add it manually, we might have to do this a lot, so clearly we need
    # to make it automatic or solve the BSD/GNU gettext conflict in another
    # way
    gettext = Formula.factory 'gettext'
    inreplace lib+'pkgconfig'+'glib-2.0.pc',
              'Libs: -L${libdir} -lglib-2.0 -lintl',
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext.lib} -lintl"

    (prefix+'share'+'gtk-doc').rmtree
  end
end
