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

class Asymptote < Formula
  homepage 'http://asymptote.sourceforge.net/'
  url 'http://downloads.sourceforge.net/asymptote/asymptote-2.15.src.tgz'
  md5 '1adb969a4d7b17a3ae98728d1956bd77'

  depends_on TexInstalled.new

  depends_on 'readline'
  depends_on 'bdw-gc'

  def install
    texmfhome = share+'texmf'

    # see: https://sourceforge.net/tracker/?func=detail&aid=3486838&group_id=120000&atid=685683
    inreplace 'configure', '--no-var-tracking', '' if ENV.compiler == :clang

    system "./configure", "--prefix=#{prefix}",
                          "--enable-gc=#{HOMEBREW_PREFIX}",
                          "--with-latex=#{texmfhome}/tex/latex",
                          "--with-context=#{texmfhome}/tex/context/third",
                          # So that `texdoc` can find manuals
                          "--with-docdir=#{texmfhome}/doc"
    system "make"
    ENV.deparallelize
    system "make install"
  end

  def test
    ENV['TEXMFHOME'] = "#{HOMEBREW_PREFIX}/share/texmf"
    mktemp do
      (Pathname.pwd+'asy_test.tex').write <<-EOS.undent
        \\nonstopmode

        \\documentclass{minimal}
        \\usepackage{asymptote}

        \\begin{document}
        Hello, Asymptote!

        \\begin{asy}
          size(3cm);
          draw((0,0)--(1,0)--(1,1)--(0,1)--cycle);
        \\end{asy}

        \\end{document}
      EOS

      system "pdflatex asy_test"
      system "asy asy_test-1.asy"
      system "pdflatex asy_test"
    end

    return (not $? == 0)
  end

  def caveats
    caveats = <<-EOS
1) This formula links the latest version of the Asymptote LaTeX and ConTeXt
   packages into:

       #{HOMEBREW_PREFIX}/share/texmf

   In order for these packages to be visible to TeX compilers, the above
   directory will need to be added to the TeX search path:

       sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"


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
