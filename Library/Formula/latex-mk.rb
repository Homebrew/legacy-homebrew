require 'formula'

class LatexMk < Formula
  homepage 'http://latex-mk.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/latex-mk/files/latex-mk/latex-mk-2.1/latex-mk-2.1.tar.gz'
  sha1 '8460fd1f3c716e5759828c2a5af76eeafbce8d10'

  env :userpaths

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "latex-mk requires a version of TeX, such as TeX Live or MacTeX."
  end

end
