class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "http://proofgeneral.inf.ed.ac.uk"
  url "http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.2.tgz"
  sha256 "3567b68077798396ccd55c501b7ea7bd2c4d6300e4c74ff609dc19837d050b27"

  devel do
    url "http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.3pre150313.tgz"
    sha256 "6e7095fe76f9d750fff3ee1de2415ed1014d4bacdd4f62192eb99330e7f405cb"
  end

  option "with-doc", "Install HTML documentation"

  depends_on :emacs => "23.3"

  def install
    ENV.j1 # Otherwise lisp compilation can result in 0-byte files

    args = ["PREFIX=#{prefix}",
            "DEST_PREFIX=#{prefix}",
            "ELISPP=share/emacs/site-lisp/ProofGeneral",
            "ELISP_START=#{share}/emacs/site-lisp/site-start.d",
            "EMACS=#{which "emacs"}"]

    cd "ProofGeneral" do
      # http://proofgeneral.inf.ed.ac.uk/trac/ticket/458
      # remove in next stable release
      inreplace "Makefile", "(setq byte-compile-error-on-warn t)", "" if build.stable?
      system "make", "install", *args
      man1.install "doc/proofgeneral.1"
      info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"

      doc.install "doc/ProofGeneral", "doc/PG-adapting" if build.with? "doc"
    end
  end

  def caveats
    doc = ""
    if build.with? "doc"
      doc += <<-EOS.undent
        HTML documentation is available in: #{HOMEBREW_PREFIX}/share/doc/proof-general
      EOS
    end

    <<-EOS.undent
    To use ProofGeneral with Emacs, add the following line to your ~/.emacs file:
      (load-file "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")
    #{doc}
    EOS
  end

  test do
    system bin/"proofgeneral", "--help"
  end
end
