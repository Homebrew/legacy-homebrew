require 'formula'

class Ddskk < Formula
  url 'http://openlab.ring.gr.jp/skk/maintrunk/ddskk-14.3.tar.gz'
  homepage 'http://openlab.ring.gr.jp/skk/ddskk.html'
  md5 'af8aab148acc9c3861b9f0faba6fe9c8'

  depends_on 'apel'

  def install
    open("SKK-CFG", 'a'){|f| f.puts(<<DATA) }
(setq APEL_DIR "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/apel")
(setq EMU_DIR "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/emu")
(setq SKK_DATADIR "#{HOMEBREW_PREFIX}/share/skk")
(setq SKK_INFODIR "#{HOMEBREW_PREFIX}/info")
(setq SKK_LISPDIR "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/skk")
(setq SKK_SET_JISYO t)
DATA

    system "make"
    system "make install"
  end
end
