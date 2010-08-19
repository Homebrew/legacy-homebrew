require 'formula'

class Igraph <Formula
  url 'http://switch.dl.sourceforge.net/sourceforge/igraph/igraph-0.5.3.tar.gz'
  homepage 'http://igraph.sourceforge.net'
  md5 '0b5437a387a1c91985b99656f877edcd'

  depends_on 'glpk'
  depends_on 'gmp'

  def install
    fails_with_llvm "Segfault while compiling."

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
