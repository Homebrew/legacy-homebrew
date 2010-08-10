require 'formula'

class Csshx < Formula
  url 'http://csshx.googlecode.com/files/csshX-0.72.tgz'
  homepage 'http://code.google.com/p/csshx/'
  md5 '15178bbdaaa8f949bd583bd639577232'
  head 'http://csshx.googlecode.com/svn/trunk/'

  def install
    bin.install 'csshX'
  end
end
