require 'formula'

class Apel < Formula
  url 'http://kanji.zinbun.kyoto-u.ac.jp/~tomo/lemi/dist/apel/apel-10.8.tar.gz'
  homepage 'http://www.kanji.zinbun.kyoto-u.ac.jp/~tomo/elisp/APEL/index.en.html'
  md5 '20b82300094b4377e1fb74d83ebbd972'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"

    mkdir_p "#{HOMEBREW_PREFIX}/share/emacs/site-lisp"

    ln_s "#{prefix}/share/emacs/site-lisp/apel", "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/"
    ln_s "#{prefix}/share/emacs/site-lisp/emu", "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/"
  end
end
