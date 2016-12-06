require 'formula'

class OrgMode < Formula
  url 'http://orgmode.org/org-7.7.tar.gz'
  homepage 'http://orgmode.org'
  md5 '236289876d9c33ac47c6383ec738ce6a'
  head 'git://orgmode.org/org-mode.git'

  depends_on 'emacs'

  def install
    system "make"
  end

  def caveats; <<-EOS.undent
    To load org-mode in your emacs configuration, add the following
    to your ~/.emacs file:
    
       (setq load-path (cons "#{prefix}/lisp" load-path))
       (require 'org-install)
       (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

    To load org-mode contrib:

        (setq load-path (cons "#{prefix}/contrib/lisp" load-path))
    EOS
  end
end
