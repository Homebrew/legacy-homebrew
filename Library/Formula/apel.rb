class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "LISPDIR=#{share}/emacs/site-lisp/apel",
           "VERSION_SPECIFIC_LISPDIR=#{share}/emacs/site-lisp/apel"
  end

  test do
    program = testpath/"test-apel.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/apel/emu")
      (require 'poe)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
