require 'brewkit'

# TODO keywords for search include 'exuberant'

class Ctags <Formula
  @url='http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  @homepage='http://ctags.sourceforge.net/'
  @md5='c00f82ecdcc357434731913e5b48630d'

  def install
    system "./configure", "--prefix='#{prefix}'",
                          "--enable-macro-patterns",
                          "--mandir='#{man}'",
                          "--with-readlib"
    system "make install"
  end
end
