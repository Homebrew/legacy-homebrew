require 'formula'

class Pnapi < Formula
  homepage 'http://service-technology.org/tools/petri_net_api'
  url 'http://download.gna.org/service-tech/pnapi/pnapi-4.02.tar.gz'
  sha1 'caa61aaa5886381e594f7eb57a75c1feb6960c3a'

  depends_on "graphviz"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    # for some reason config.h is not installed by the Makefile
    (include/'pnapi').install 'src/config.h'
  end

  def test
    system "#{bin}/petri", "--help"
  end
end
