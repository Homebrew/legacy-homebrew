require 'formula'

class MdaLv2 < Formula
  homepage 'http://drobilla.net/software/mda-lv2/'
  url 'http://download.drobilla.net/mda-lv2-1.2.2.tar.bz2'
  sha1 'f96f56f92160e4f1e3813fedec43775d1cc621ef'

  depends_on 'pkg-config' => :build
  depends_on 'lv2'

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf"
    system "./waf", "install"
  end
end
