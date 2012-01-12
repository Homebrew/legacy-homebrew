require 'formula'

class Auctex < Formula
  url 'http://ftpmirror.gnu.org/auctex/auctex-11.86.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/auctex/auctex-11.86.tar.gz'
  homepage 'http://ftp.gnu.org/pub/gnu/auctex'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  def options
    [
     ['--with-emacs=/full/path/to/emacs>', "Force a different emacs"]
    ]
  end

  def which_emacs
    emacs = `which emacs`.chomp
    # check arguments for a different emacs
    ARGV.each do |a|
      if a.index('--with-emacs')
        emacs = a.sub('--with-emacs=', '')
      end
    end
    return emacs
  end

  def install
    # based on the asymtote formula LaTeX check
    if `which latex`.chomp == ''
      onoe <<-EOS.undent
        AUCTeX requires a TeX/LaTeX installation; aborting now.
        You can obtain the TeX distribution for Mac OS X from
            http://www.tug.org/mactex/
      EOS
      Process.exit
    end

    brew_lispdir = share + 'emacs' + 'site-lisp'
    brew_texmf = share + 'texmf'
    # configure fails if the texmf dir is not there yet
    brew_texmf.mkpath

    system "./configure", "--prefix=#{prefix}", "--with-texmf-dir=#{brew_texmf}",
                          "--with-emacs=#{which_emacs}", "--with-lispdir=#{brew_lispdir}"

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
    * texmf files installed into
        #{HOMEBREW_PREFIX}/share/texmf/
      you can add it to your TEXMFHOME using:
        sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    * Emacs package installed into
        #{HOMEBREW_PREFIX}/share/emacs/site-lisp
      to activate add the following to your .emacs:
#{dot_emacs}
    EOS
  end

end
