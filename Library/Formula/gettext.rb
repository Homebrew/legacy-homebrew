require 'brewkit'

class Gettext <Formula
  @url='http://ftp.gnu.org/pub/gnu/gettext/gettext-0.17.tar.gz'
  @md5='58a2bc6d39c0ba57823034d55d65d606'
  @homepage='http://www.gnu.org/software/gettext/'

  def patches
    'http://gist.github.com/raw/186336/2fe65fab894f94a03aab2f03349ae7f1febcd301/mac-osx-105-environ.patch'
  end

  def keg_only?
    "OS X provides the BSD gettext library and some software gets confused if both are in the library path."
  end

  def install
    ENV.libxml2
    # TODO seems like this package needs more optmisation
    # maybe someone can tell me how glib depends on gettext, but gettext 
    # depends on glib and thus includes its own?!
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                        # '--disable-nls ',
                          '--without-emacs', 
                          '--without-included-gettext',
                          '--without-included-glib',
                          '--without-included-libcroco',
                          '--without-included-libxml'
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"

    (doc+'examples').rmtree unless ARGV.include? '--with-examples'
  end
end
