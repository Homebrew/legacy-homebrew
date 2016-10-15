require "formula"

class Apel < Formula
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha1 "089c18ae006df093aa2edaeb486bfaead6ac4918"

  def install
    system "make PREFIX=#{prefix} LISPDIR=#{share}/emacs/site-lisp VERSION_SPECIFIC_LISPDIR=#{share}/emacs/site-lisp"
    system "make install PREFIX=#{prefix} LISPDIR=#{share}/emacs/site-lisp VERSION_SPECIFIC_LISPDIR=#{share}/emacs/site-lisp"
    system "mv #{share}/emacs/site-lisp/apel/* #{share}/emacs/site-lisp; rmdir #{share}/emacs/site-lisp/apel"
    system "mv #{share}/emacs/site-lisp/emu/* #{share}/emacs/site-lisp; rmdir #{share}/emacs/site-lisp/emu"
  end
end
