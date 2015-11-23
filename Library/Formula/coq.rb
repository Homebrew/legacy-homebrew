class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

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
    revision 1
    sha256 "6b3ae59be4da7b75d60b3fdaa75c6cbb9f602d96b343cb4233b59aa6ff4103ae" => :el_capitan
    sha256 "bc93e42389818072869eac34d3d06985bce3d6d97048a2ae01e3f94296f535d2" => :yosemite
    sha256 "10fd3a34aee2f907a4d4c71d694100c1e1df207fd6dd9a6c9b2ea50423330a17" => :mavericks
  end

  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

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
