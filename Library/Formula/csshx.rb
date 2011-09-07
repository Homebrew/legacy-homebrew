require 'formula'

class Csshx < Formula
  url 'http://csshx.googlecode.com/files/csshX-0.73.tgz'
  homepage 'http://code.google.com/p/csshx/'
  md5 'ba5fc81f6ccb43c9f5908dbfd5901576'
  head 'http://csshx.googlecode.com/svn/trunk/'

  def install
    bin.install 'csshX'
  end
end
