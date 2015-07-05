class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").include?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://coq.inria.fr/distrib/V8.4pl6/files/coq-8.4pl6.tar.gz"
  version "8.4pl6"
  sha256 "a540a231a9970a49353ca039f3544616ff86a208966ab1c593779ae13c91ebd6"
  revision 1

  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "59f6e0b26fbb0be09c8ea9959ea25b60cd4ce9f424e126d58478500cc2965a9b" => :yosemite
    sha256 "dcf2a61af6f3ea17d25a4201d32ffea2b0b7644d134d4f4517822946f0138e4e" => :mavericks
    sha256 "dd082d214e2540429c6f757a41e4df23307e339d50ae68cd108dbd569c6b9ed1" => :mountain_lion
  end

  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "objective-caml"

  def install
    camlp5_lib = Formula["camlp5"].opt_lib+"ocaml/camlp5"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{share}/emacs/site-lisp/coq",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make", "world"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To use the Coq Emacs mode, add the the following to your init file:
      (setq auto-mode-alist (cons '("\\\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
  end
end
