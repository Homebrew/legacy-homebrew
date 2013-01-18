require 'formula'

class Hyperspec < Formula
  homepage 'http://www.lispworks.com/documentation/common-lisp.html'
  url 'ftp://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz'
  version '7.0'
  sha1 '7c89db8a930b7bd1fd204a458a5dd05d7d46ab81'

  def install
    doc.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use this copy of the HyperSpec with SLIME, put the following in
    you .emacs intialization file:

    (eval-after-load "slime"
      '(progn
         (setq common-lisp-hyperspec-root
               "#{HOMEBREW_PREFIX}/share/doc/hyperspec/HyperSpec/")
         (setq common-lisp-hyperspec-symbol-table
               (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
         (setq common-lisp-hyperspec-issuex-table
               (concat common-lisp-hyperspec-root "Data/Map_IssX.txt"))))

    EOS
  end
end
