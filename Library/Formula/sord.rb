require 'formula'

class Sord < Formula
  homepage 'http://drobilla.net/software/sord/'
  url 'http://download.drobilla.net/sord-0.10.4.tar.bz2'
  sha1 '7ac6b593bf391b5670fec178ed7bf81b081094b5'

  depends_on 'pkg-config' => :build
  depends_on 'serd'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
