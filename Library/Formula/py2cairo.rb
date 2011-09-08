require 'formula'

class Py2cairo < Formula
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  homepage 'http://cairographics.org/pycairo/'
  md5 '20337132c4ab06c1146ad384d55372c5'

  depends_on 'native-cairo'

  def install
    # TODO: figure out if this is the "right way" to do this
    ENV['ARCHFLAGS'] = "-arch x86_64"
    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "/usr/bin/false"
  end
end
