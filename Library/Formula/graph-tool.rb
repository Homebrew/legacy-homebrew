require 'formula'

class GraphTool < Formula
  homepage 'http://projects.skewed.de/graph-tool/'
  url 'http://downloads.skewed.de/graph-tool/graph-tool-2.2.17.tar.bz2'
  sha1 '6e6197a2f8598ce9f0fb90aa95a866617c44b125'

  depends_on :x11
  depends_on 'boost'
  depends_on 'scipy' => :python
  depends_on 'numpy' => :python
  depends_on 'matplotlib' => :python
  depends_on 'cgal'
  depends_on 'pkg-config' => :build
  depends_on 'cairomm'
  depends_on 'py2cairo'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
