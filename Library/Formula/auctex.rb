require 'formula'

class TexInstalled < Requirement
  def message; <<-EOS.undent
    A TeX/LaTeX installation is required to install.
    You can obtain the TeX distribution for Mac OS X from:
        http://www.tug.org/mactex/
    EOS
  end
  def satisfied?
    which 'latex'
  end
  def fatal?
    true
  end
end

class Auctex < Formula
  homepage 'http://ftp.gnu.org/pub/gnu/auctex'
  url 'http://ftpmirror.gnu.org/auctex/auctex-11.86.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/auctex/auctex-11.86.tar.gz'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  depends_on TexInstalled.new

  def options
    [['--with-emacs=</full/path/to/emacs>', "Force a different emacs"]]
  end

  def which_emacs
    # check arguments for a different emacs
    ARGV.each do |a|
      if a.index('--with-emacs')
        return a.sub('--with-emacs=', '')
      end
    end
    return `which emacs`.chomp
  end

  def install
    # configure fails if the texmf dir is not there yet
    brew_texmf = share + 'texmf'
    brew_texmf.mkpath

    system "./configure", "--prefix=#{prefix}",
                          "--with-texmf-dir=#{brew_texmf}",
                          "--with-emacs=#{which_emacs}",
                          "--with-lispdir=#{share}/emacs/site-lisp"

    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make install"
  end

  def caveats
    # check if the used emacs is in HOMEBREW_PREFIX/bin
    # for which case HOMEBREW_PREFIX/share/emacs/site-lisp should already
    # be by default in the load-path
    if which_emacs.index("#{HOMEBREW_PREFIX}/bin")
      dot_emacs = <<-EOS
      (require 'tex-site)
      EOS
    else
      dot_emacs = <<-EOS
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (require 'tex-site)
      EOS
    end

    <<-EOS.undent
    texmf files installed into:
      #{HOMEBREW_PREFIX}/share/texmf/

    You can add it to your TEXMFHOME using:
      sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    Emacs package installed into:
      #{HOMEBREW_PREFIX}/share/emacs/site-lisp

    To activate, add the following to your .emacs:
#{dot_emacs}
    EOS
  end

end
