require 'formula'

class ProofGeneral < Formula
  url 'http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.1RC2.tgz'
  homepage 'http://proofgeneral.inf.ed.ac.uk/'
  md5 'd1dddaaa28cac80a5e3b65f2a9f503af'

  depends_on 'emacs' if ARGV.include? '--compile-elc'

  def options
    [['--compile-elc', "Compiles elc files with your emacs"]]
  end

  def install
    Dir.chdir "ProofGeneral" do
        system "make clean" if ARGV.include? '--compile-elc'
        system "make install PREFIX=#{prefix} DEST_PREFIX=#{prefix}"
    end
  end

  def caveats; <<-EOS.undent
    To use ProofGeneral with Emacs, add the following line to your ~/.emacs file:
    (load-file "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")
    EOS
  end
end
