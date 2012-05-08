require 'formula'

class Pnapi < Formula
  homepage 'http://service-technology.org/tools/petri_net_api'
  url 'http://download.gna.org/service-tech/pnapi/pnapi-4.02.tar.gz'
  md5 '35a02b583cc413049d3db1e453a54e75'

  depends_on "graphviz"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    # for some reason config.h is not installed by the Makefile
    include.join('pnapi').install 'src/config.h'
  end

  def test
    system "petri --help"
  end
end
