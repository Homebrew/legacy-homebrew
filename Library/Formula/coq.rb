require 'formula'

class TransitionalMode < Requirement
  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
  def satisfied?
    # If not installed, it will install in the correct mode.
    return true if not which('camlp5')
    # If installed, make sure it is transitional instead of strict.
    `camlp5 -pmode 2>&1`.chomp == 'transitional'
  end
  def fatal?
    true
  end
end

class Coq < Formula
  homepage 'http://coq.inria.fr/'
  url 'http://coq.inria.fr/distrib/V8.4/files/coq-8.4.tar.gz'
  md5 'f28662cd687f66ed3c372ca3d35ea928'
  head 'svn://scm.gforge.inria.fr/svn/coq/trunk'

  skip_clean :all

  depends_on TransitionalMode.new
  depends_on 'objective-caml'
  depends_on 'camlp5'

  def install
    arch = Hardware.is_64_bit? ? "x86_64" : "i386"
    camlp5_lib = Formula.factory('camlp5').lib+'ocaml/camlp5'
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{lib}/emacs/site-lisp",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-coqide", "no",
                          "-with-doc", "no",
                          "-arch", arch
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make world"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Coq's Emacs mode is installed into
      #{lib}/emacs/site-lisp

    To use the Coq Emacs mode, you need to put the following lines in
    your .emacs file:
      (setq auto-mode-alist (cons '("\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
  end
end
