require 'formula'

class Ctags <Formula
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  homepage 'http://ctags.sourceforge.net/'
  md5 'c00f82ecdcc357434731913e5b48630d'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  def patches
  	"https://gist.github.com/raw/837648/c98b02f225f1d07c0bef5447d41762e33c4e4217/ctags-5.8-css.patch"
  end

  def install
	system "wget --no-check-certificate https://github.com/fishman/ctags/raw/deploy/css.c"

    system "autoheader" if ARGV.build_head?
    system "autoconf" if ARGV.build_head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make install"
  end
end
