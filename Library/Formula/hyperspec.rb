class Hyperspec < Formula
  desc "Common Lisp ANSI-standard Hyperspec"
  homepage "http://www.lispworks.com/documentation/common-lisp.html"
  url "ftp://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz"
  version "7.0"
  sha256 "1ac1666a9dc697dbd8881262cad4371bcd2e9843108b643e2ea93472ba85d7c3"

  bottle :unneeded

  def install
    doc.install Dir["*"]
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

  test do
    assert (doc/"HyperSpec-README.text").exist?
  end
end
