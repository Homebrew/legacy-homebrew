require 'formula'

class Sord < Formula
  homepage 'http://drobilla.net/software/sord/'
  url 'http://download.drobilla.net/sord-0.12.0.tar.bz2'
  sha1 '8a1ae8c9f90bd0b3632841898c6500a8293d6ed2'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'serd'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
