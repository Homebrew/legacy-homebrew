require 'formula'

class Sratom < Formula
  homepage 'http://drobilla.net/software/sratom/'
  url 'http://download.drobilla.net/sratom-0.4.0.tar.bz2'
  sha1 '898ef54df92785a2cfe2787ff2002e0b713044fd'

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
