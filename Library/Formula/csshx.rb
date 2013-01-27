require 'formula'

class Csshx < Formula
  homepage 'http://code.google.com/p/csshx/'
  url 'http://csshx.googlecode.com/files/csshX-0.74.tgz'
  sha1 'aa686b71161d6144d539d077b960da10d7b96993'

  head 'https://code.google.com/p/csshx/', :using => :git

  def install
    bin.install 'csshX'
  end
end
