require 'formula'

class Sratom < Formula
  homepage 'http://drobilla.net/software/sratom/'
  url 'http://download.drobilla.net/sratom-0.4.2.tar.bz2'
  sha1 'cd3c88034c93af059b67c9def965821d4a7ba297'

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
