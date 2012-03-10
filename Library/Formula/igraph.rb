require 'formula'

class Igraph < Formula
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.5.4.tar.gz'
  homepage 'http://igraph.sourceforge.net'
  md5 '47963ece64fe5f793e154e238bc6c3c3'

  depends_on 'glpk'
  depends_on 'gmp'

  fails_with_llvm "Segfault while compiling."

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
