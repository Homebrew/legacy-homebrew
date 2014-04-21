require 'formula'

class LatexMk < Formula
  homepage 'http://latex-mk.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/latex-mk/latex-mk/latex-mk-2.1/latex-mk-2.1.tar.gz'
  sha1 '8460fd1f3c716e5759828c2a5af76eeafbce8d10'

  depends_on :tex

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
