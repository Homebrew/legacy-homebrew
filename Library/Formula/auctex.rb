require 'formula'

class Auctex < Formula
  url 'http://ftp.gnu.org/pub/gnu/auctex/auctex-11.86.tar.gz'
  homepage 'http://ftp.gnu.org/pub/gnu/auctex'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  def options
    [
     ['--with-emacs=/full/path/to/emacs>', "Force a different emacs"]
    ]
  end

  def which_emacs
    emacs = `which emacs`.chop
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
    if `which latex` == ''
      onoe <<-EOS.undent
        AUCTeX requires a TeX/LaTeX installation; aborting now.
        You can obtain the TeX distribution for Mac OS X from
            http://www.tug.org/mactex/
      EOS
      Process.exit
    end

    # create brew dirs for
    # - texmf components
    # - emacs site-lisp
    brew_texmf = File.join HOMEBREW_PREFIX, 'share', 'texmf'
    brew_lispdir = File.join HOMEBREW_PREFIX, 'share', 'emacs', 'site-lisp'
    [brew_texmf+'/tex/latex', brew_texmf+'/doc/latex/styles', brew_lispdir].each do |d|
      if !File.directory? d
        mkdir_p d
      end
    end

    # local tmp dir for texmf and site-lisp
    texmf = File.join Dir.pwd, 'texmf'
    lispdir = File.join Dir.pwd, 'site-lisp'
    mkdir_p texmf
    mkdir_p lispdir

    system "./configure", "--prefix=#{prefix}", "--with-texmf-dir=#{texmf}",
                          "--with-emacs=#{which_emacs}", "--with-lispdir=#{lispdir}"
    system "make"
    system "make install"
    (share+'texmf').install Dir[texmf+'/*']
    (share+'emacs/site-lisp').install Dir[lispdir+'/*']
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

    puts <<-EOS.undent
    * texmf files installed into
        #{HOMEBREW_PREFIX}/share/texmf/
      you can add it to your TEXMFHOME using
        sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    * Emacs package installed into
        #{HOMEBREW_PREFIX}/share/emacs/site-lisp
      to activate add the following to your .emacs
#{dot_emacs}
    EOS
  end

end
