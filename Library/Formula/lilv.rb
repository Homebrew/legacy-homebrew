require 'formula'

class Lilv < Formula
  homepage 'http://drobilla.net/software/lilv/'
  url 'http://download.drobilla.net/lilv-0.14.4.tar.bz2'
  sha1 '1f04d7363038ba09e794dc5ab510e70423762426'

  depends_on 'pkg-config' => :build
  depends_on 'lv2'
  depends_on 'serd'
  depends_on 'sord'
  depends_on 'sratom'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
