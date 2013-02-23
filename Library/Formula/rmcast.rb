require 'formula'

class Rmcast < Formula
  homepage 'http://www.land.ufrj.br/tools/rmcast/rmcast.html'
  url 'http://www.land.ufrj.br/tools/rmcast/download/rmcast-2.0.0.tar.gz'
  sha1 '43146066d3199fc811b207e427135d2a14b8e971'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
