require 'formula'

class Ctags <Formula
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  homepage 'http://ctags.sourceforge.net/'
  md5 'c00f82ecdcc357434731913e5b48630d'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  def install
    system "autoheader" if ARGV.build_head?
    system "autoconf" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make install"
  end
end
