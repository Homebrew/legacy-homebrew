require 'formula'

class Gettext < Formula
  url 'http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.1.1.tar.gz'
  md5 '3dd55b952826d2b32f51308f2f91aa89'
  homepage 'http://www.gnu.org/software/gettext/'

  keg_only "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  def options
    [['--with-examples', 'Keep example files.']]
  end

  def install
    ENV.libxml2
    ENV.O3 # Issues with LLVM & O4 on Mac Pro 10.6

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-included-gettext",
                          "--without-included-glib",
                          "--without-included-libcroco",
                          "--without-included-libxml",
                          "--without-emacs"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make install"

    (doc+'examples').rmtree unless ARGV.include? '--with-examples'
  end
end
