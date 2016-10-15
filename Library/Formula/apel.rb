require "formula"

class Apel < Formula
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha1 "089c18ae006df093aa2edaeb486bfaead6ac4918"

  def install
    system "make", "PREFIX=#{prefix}",
           "LISPDIR=#{share}/emacs/site-lisp",
           "VERSION_SPECIFIC_LISPDIR=#{share}/emacs/site-lisp"
    system "make", "install", "PREFIX=#{prefix}",
           "LISPDIR=#{share}/emacs/site-lisp",
           "VERSION_SPECIFIC_LISPDIR=#{share}/emacs/site-lisp"
    (share/'emacs/site-lisp').install Dir["#{share}/emacs/site-lisp/emu/*"],
                                      Dir["#{share}/emacs/site-lisp/apel/*"]
  end

  test do
    program = testpath/"test-apel.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'poe)
      (print (minibuffer-prompt-width))
    EOS

    assert_equal "0", shell_output("emacs -batch -l #{program}").strip
  end

end
