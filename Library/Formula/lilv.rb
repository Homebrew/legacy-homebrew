require 'formula'

class Lilv < Formula
  homepage 'http://drobilla.net/software/lilv/'
  url 'http://download.drobilla.net/lilv-0.20.0.tar.bz2'
  sha1 'b3a7d0089b16b04114895d47a898b8d494774927'

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
