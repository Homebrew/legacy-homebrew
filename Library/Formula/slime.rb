require 'formula'

class Slime < Formula
  head 'cvs://:pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot:slime'
  homepage 'http://www.common-lisp.net/project/slime/'

  def options
    [
     ["--with-docs", "Install docs"]
    ]
  end

  def install
    # Installation is just a straight copy of the .el and .lisp
    # contents of the CVS checkout into site-lisp/slime
    slime = share+'emacs'+'site-lisp'+'slime'
    slime.mkpath
    slime.install Dir['*.el', '*.lisp']

    if ARGV.include? "--with-docs"
      doc.install 'doc/slime-refcard.pdf'

      ## For 'sort' in doc Makefile to generate contributors.texi
      ENV['LC_ALL'] = 'C'
      system "make -C doc -e slime.info"

      info.install 'doc/slime.info'
    end
  end

  def caveats; <<-EOS
* elisp and lisp files installed into

    #{HOMEBREW_PREFIX}/emacs/site-lisp/slime


* If you chose --with-docs and are missing the info pages,
  try again with HOMEBREW_KEEP_INFO set:

    HOMEBREW_KEEP_INFO=1 brew install --HEAD --with-docs slime


* To activate, add the following to your .emacs:

  (add-to-list 'load-path "#{HOMEBREW_PREFIX}/emacs/site-lisp/slime")

  ;; basic, no-frills slime package
  (require 'slime)
  (slime-setup)

  ;; or the high-speed, low-drag, laser-guided slime kit:
  (require 'slime-autoloads)
  (slime-setup '(slime-fancy))

EOS
  end
end
