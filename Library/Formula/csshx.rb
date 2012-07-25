require 'formula'

class Csshx < Formula
  url 'http://csshx.googlecode.com/files/csshX-0.74.tgz'
  homepage 'http://code.google.com/p/csshx/'
  md5 '5e25d4812d98c3a6b2436aaf4e23c02c'

  head 'https://code.google.com/p/csshx/', :using => :git

  def install
    bin.install 'csshX'
  end
end
