require 'formula'

class MdaLv2 < Formula
  homepage 'http://drobilla.net/software/mda-lv2/'
  url 'http://download.drobilla.net/mda-lv2-1.0.0.tar.bz2'
  sha1 '03ad1115405bbc870b3cd10f557f326b38cbb74d'

  depends_on 'pkg-config' => :build
  depends_on 'lv2'

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf"
    system "./waf", "install"
  end
end
