require 'formula'

def TeX_installed?; return `which latex` != ''; end

class Asymptote <Formula
  url 'http://downloads.sourceforge.net/asymptote/asymptote-2.05.src.tgz'
  homepage 'http://asymptote.sourceforge.net/'
  md5 '9194e477a47869f3039ad9ac917924d3'

  depends_on 'readline'
  depends_on 'bdw-gc'

  def link_asy_texmfhome
    texmfhome = `kpsewhich -var-value=TEXMFHOME`.chop
    texmflocl = `kpsewhich -var-value=TEXMFLOCAL`.chop

    asyhome = "#{texmfhome}/tex/latex/asymptote-brew"
    asylocl = "#{texmflocl}/tex/latex/asymptote"
    system "mkdir -p #{asyhome}"

    for asyfile in ['asycolors.sty','asymptote.sty','ocg.sty','latexmkrc']
      system "ln -s -f #{asylocl}/#{asyfile} #{asyhome}/#{asyfile}"
    end
  end

  def install
    unless TeX_installed?
      onoe <<-EOS.undent
        Asymptote requires a TeX/LaTeX installation; aborting now.
        You can obtain the TeX distribution for Mac OS X from
            http://www.tug.org/mactex/
      EOS
      exit 1
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-gc=#{HOMEBREW_PREFIX}"
    system "make install"
    link_asy_texmfhome
  end

  def caveats
    caveats = <<-EOS
1) This formula links the latest version of asymptote.sty into your user
   texmf directory:

       ~/Library/texmf/tex/asymptote-brew/asymptote.sty

   This file links back to where the Asymptote source installer puts it:

       /usr/local/texlive/texmf-local/tex/latex/asymptote/asymptote.sty

   Other users of your machine will not be able to use the source-installed
   version of asymptote.sty unless they perform a similar linking operation;
   e.g.,

       mkdir -p ~/Library/texmf/tex/asymptote-brew/
       ln -s /usr/local/texlive/texmf-local/tex/latex/asymptote/asymptote.sty  ~/Library/texmf/tex/asymptote-brew/asymptote.sty

   and similarly for asycolors.sty, ocg.sty, and latexmkrc.

   If you are not using MacTeX / TeX Live or you have customised your TeX
   distribution, the paths shown above may not match your particular system,
   but you get the idea.


2) If you want to have Asymptote compiled with support for fftw or gsl
   (fast fourier transforms or the GNU Scientific Library) they must be
   manually installed first:

       brew install fftw
       brew install gsl

   They are not compiled by default because they take a long time to compile
   and they are not required by most users. (And they're not included in the
   TeX Live build of Asymptote.)


3) If you wish to use xasy, you must first install the Python Imaging
   Library (PIL):

       easy_install http://effbot.org/downloads/Imaging-1.1.7.tar.gz

    EOS
  end
end
