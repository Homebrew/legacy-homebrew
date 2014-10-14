require 'formula'

class Lilv < Formula
  homepage 'http://drobilla.net/software/lilv/'
  url 'http://download.drobilla.net/lilv-0.16.0.tar.bz2'
  sha1 '072477ae0e4e6ae4a9534ea8a35e25f00601c838'

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
