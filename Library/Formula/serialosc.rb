require 'formula'

class Serialosc < Formula
  homepage 'http://docs.monome.org/doku.php?id=app:serialosc'
  url 'https://github.com/monome/serialosc/tarball/1.2'
  sha1 'a5eb073df2e4882baf7adb3ae35a92b861652977'

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
