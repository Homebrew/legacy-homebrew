require 'formula'

class Gettext <Formula
  url 'http://ftp.gnu.org/pub/gnu/gettext/gettext-0.17.tar.gz'
  md5 '58a2bc6d39c0ba57823034d55d65d606'
  homepage 'http://www.gnu.org/software/gettext/'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  def patches
    'http://gist.github.com/raw/186336/2fe65fab894f94a03aab2f03349ae7f1febcd301/mac-osx-105-environ.patch'
  end

  def options
    [['--with-examples', 'Keep example files.']]
  end

  def install
    ENV.libxml2
    ENV.O3 # Issues with LLVM & O4 on Mac Pro 10.6

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-emacs",
                          "--without-included-gettext",
                          "--without-included-glib",
                          "--without-included-libcroco",
                          "--without-included-libxml"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"

    (doc+'examples').rmtree unless ARGV.include? '--with-examples'
  end
end
