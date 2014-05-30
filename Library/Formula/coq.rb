require "formula"

class TransitionalMode < Requirement
  fatal true

  satisfy do
    Tab.for_name("camlp5").unused_options.include? "strict"
  end

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  homepage "http://coq.inria.fr/"
  url "http://coq.inria.fr/distrib/V8.4pl4/files/coq-8.4pl4.tar.gz"
  version "8.4pl4"
  sha1 "4dfc3a1ae65f5c480ddc4387d21549a526183e00"

  head "git://scm.gforge.inria.fr/coq/coq.git"

  depends_on TransitionalMode
  depends_on "objective-caml"
  depends_on "camlp5"

  def install
    camlp5_lib = Formula["camlp5"].opt_lib+"ocaml/camlp5"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{lib}/emacs/site-lisp",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make", "world"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Coq's Emacs mode is installed into
      #{opt_lib}/emacs/site-lisp

    To use the Coq Emacs mode, you need to put the following lines in
    your .emacs file:
      (setq auto-mode-alist (cons '("\\\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
  end
end
