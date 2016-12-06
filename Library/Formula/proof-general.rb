require 'formula'

class ProofGeneral < Formula
  homepage 'http://proofgeneral.inf.ed.ac.uk/'
  url 'http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.1.tgz'
  md5 'a04ebe2c6b56a4fd6c16a070ea7fe3a9'

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
