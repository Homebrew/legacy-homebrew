require 'formula'

class Auctex < Formula
  url 'http://ftp.gnu.org/pub/gnu/auctex/auctex-11.86.tar.gz'
  homepage 'http://ftp.gnu.org/pub/gnu/auctex'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  def install
    # based on the asymtote formula LaTeX check
    if `which latex`.strip == ''
      onoe <<-EOS.undent
        AUCTeX requires a TeX/LaTeX installation; aborting now.
        You can obtain the TeX distribution for Mac OS X from
            http://www.tug.org/mactex/
      EOS
      Process.exit
    end
    texmf = `kpsewhich -var-value=TEXMFHOME`.strip
    emacs = `which emacs`.strip
    lispdir = File.join ENV['HOME'], '.emacs.d', 'auctex'
    system "./configure", "--prefix=#{prefix}", "--with-texmf-dir=#{texmf}",
                          "--with-emacs=#{emacs}", "--with-lispdir=#{lispdir}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    * texmf files installed into
      ~/Library/texmf/tex/preview

    * Emacs package installed into
      ~/.emacs.d/auctex

    * to activate add the following to your .emacs
      (add-to-list 'load-path "~/.emacs.d/auctex")
      (require 'tex-site)
    EOS
  end
end
