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

class LatexMk < Formula
  homepage 'http://latex-mk.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/latex-mk/files/latex-mk/latex-mk-2.1/latex-mk-2.1.tar.gz'
  sha1 '8460fd1f3c716e5759828c2a5af76eeafbce8d10'

  depends_on TexInstalled.new
  env :userpaths # To find TeX

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
