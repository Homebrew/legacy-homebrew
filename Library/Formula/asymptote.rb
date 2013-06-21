require 'formula'

class Asymptote < Formula
  homepage 'http://asymptote.sourceforge.net/'
  url 'http://downloads.sourceforge.net/asymptote/asymptote-2.23.src.tgz'
  sha1 'c24de9766ae7195c1cda947f9d2ae07497a0af8f'

  depends_on :tex
  depends_on 'texinfo'
  depends_on 'readline'
  depends_on 'bdw-gc'
  depends_on 'fftw' => :optional
  depends_on 'gsl' => :optional

  def install
    texmfhome = share/'texmf'
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

  test do
    ENV['TEXMFHOME'] = "#{HOMEBREW_PREFIX}/share/texmf"
    (testpath/'asy_test.tex').write <<-EOS.undent
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

  def caveats; <<-EOS.undent
    This formula links the latest version of the Asymptote LaTeX and ConTeXt
    packages into:

      #{HOMEBREW_PREFIX}/share/texmf

    In order for these packages to be visible to TeX compilers, the above
    directory will need to be added to the TeX search path:

      sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    If you wish to use xasy, you must first install the Python Imaging Library:

       brew install pil

    EOS
  end
end
