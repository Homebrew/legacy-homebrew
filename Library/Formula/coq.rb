require 'formula'

class Coq < Formula
  url 'http://coq.inria.fr/distrib/V8.3/files/coq-8.3.tar.gz'
  head 'svn://scm.gforge.inria.fr/svn/coq/trunk'
  homepage 'http://coq.inria.fr/'
  md5 '14b80e6b7075adf1516ab931202be8df'

  depends_on 'objective-caml'
  depends_on 'camlp5'

  def install
    unless `camlp5 -pmode 2>&1`.chomp == 'transitional'
      onoe 'camlp5 must be compiled in transitional mode (--transitional option)'
      exit 1
    end
    arch = Hardware.is_64_bit? ? "x86_64" : "i386"
    camlp5_lib = Formula.factory('camlp5').lib+'ocaml/camlp5'
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{lib}/emacs/site-lisp",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-coqide", "none",
                          "-with-doc", "no",
                          "-arch", arch
    system "make world"
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Coq's Emacs mode is installed into
      #{lib}/emacs/site-lisp
    To use the Coq Emacs mode, you need to put the following lines in
    your .emacs file:

      (setq auto-mode-alist (cons '("\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
  end
end
