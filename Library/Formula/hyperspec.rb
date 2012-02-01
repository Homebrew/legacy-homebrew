require 'formula'

class Hyperspec < Formula
  url 'ftp://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz'
  homepage 'http://www.lispworks.com/reference/HyperSpec/'
  md5 '8df440c9f1614e2acfa5e9a360c8969a'

  def install
    doc.install Dir['HyperSpec/*']
    doc.install Hash['HyperSpec-Legalese.text' => 'Legalese.txt',
                     'HyperSpec-README.text'   => 'README.txt']
  end

  def caveats ; <<-EOS
* To use your local copy of the HyperSpec in SLIME,
  put this in your .emacs file:

(setq common-lisp-hyperspec-root "#{HOMEBREW_PREFIX}/share/doc/hyperspec/"
      common-lisp-hyperspec-symbol-table (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))

EOS
end
