require 'formula'

class Auctex <Formula
  url 'http://ftp.gnu.org/pub/gnu/auctex/auctex-11.86.tar.gz'
  homepage 'http://www.gnu.org/software/auctex'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  depends_on 'emacs'

  def install
    lispdir = prefix + 'share/emacs/site-lisp'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-emacs=#{HOMEBREW_PREFIX}/bin/emacs",
                          "--without-texmf-dir", "--with-lispdir=#{lispdir}"
    system "make"
    lispdir.mkpath
    system "make install"
  end
end
