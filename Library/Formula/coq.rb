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

  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "c2978c36d4cf84212e5f9d246135f032267b04cfb5bf413620706c7b8be87c1f" => :yosemite
    sha256 "01b1fe69d4dab5f6c30891f37ce7e8999768784f02685a3a548abe37c5876e0e" => :mavericks
    sha256 "3dcdec51e2d2402d6ec9bca3f5f1d29a486995fcccfbb46e9b023f18715a4968" => :mountain_lion
  end

  depends_on Camlp5TransitionalModeRequirement
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
