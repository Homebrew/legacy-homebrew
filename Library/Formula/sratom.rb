require 'formula'

class Sratom < Formula
  homepage 'http://drobilla.net/software/sratom/'
  url 'http://download.drobilla.net/sratom-0.4.6.tar.bz2'
  sha1 '5f7d18e4917e5a2fee6eedc6ae06aa72d47fa52a'

  depends_on 'pkg-config' => :build
  depends_on 'lv2'
  depends_on 'serd'
  depends_on 'sord'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
