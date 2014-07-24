require "formula"

class Apel < Formula
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha1 "089c18ae006df093aa2edaeb486bfaead6ac4918"
  version "10.8"

  def install
    system "make LISPDIR=\/usr\/local\/share\/emacs\/site-lisp VERSION_SPECIFIC_LISPDIR=\/usr\/local\/share\/emacs\/site-lisp"
    system "make install LISPDIR=\/usr\/local\/share\/emacs\/site-lisp VERSION_SPECIFIC_LISPDIR=\/usr\/local\/share\/emacs\/site-lisp"
    system "mv /usr/local/share/emacs/site-lisp/apel/* /usr/local/share/emacs/site-lisp/"
    system "rmdir /usr/local/share/emacs/site-lisp/apel"
    system "mv /usr/local/share/emacs/site-lisp/emu/* /usr/local/share/emacs/site-lisp/"
    system "rmdir /usr/local/share/emacs/site-lisp/emu"
  end

end
