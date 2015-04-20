require 'formula'

class Serialosc < Formula
  homepage 'http://docs.monome.org/doku.php?id=app:serialosc'
  url 'https://github.com/monome/serialosc/archive/1.2.tar.gz'
  sha1 '230c3f0cb6176da6aec3b80500e175cb7f90a76a'

  head 'https://github.com/monome/serialosc.git'

  depends_on 'liblo'
  depends_on 'confuse'
  depends_on 'libmonome'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
