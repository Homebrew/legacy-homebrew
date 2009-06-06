require 'brewkit'

class Gettext <Formula
  @url='http://ftp.gnu.org/pub/gnu/gettext/gettext-0.17.tar.gz'
  @md5='58a2bc6d39c0ba57823034d55d65d606'
  @homepage='http://www.gnu.org/software/gettext/'

  def install
    # TODO seems like this package needs more optmisation
    # maybe someone can tell me how glib depends on gettext, but gettext 
    # depends on glib and thus includes its own?!

    ENV['CFLAGS']+=' -I/usr/include/libxml2'
    system "./configure --disable-debug --prefix='#{prefix}' --disable-dependency-tracking "+
#                       '--disable-nls '+
                       '--without-emacs --without-included-gettext '+
                       '--without-included-glib --without-included-libcroco '+
                       '--without-included-libxml'
    system "make"
    ENV['MAKEFLAGS']='' # can't parallel the install
    system "make install"

    (doc+'examples').rmtree unless ARGV.include? '--with-examples'
    
    def caveats
      "GNU gettext is bloated and manky, please try not to depend on it"
    end
  end
end
