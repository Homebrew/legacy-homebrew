require 'formula'

class Picocom < Formula
  url 'http://picocom.googlecode.com/files/picocom-1.4.tar.gz'
  homepage 'http://code.google.com/p/picocom/'
  md5 '08fcc5f6bb9e7676a2569386d5ea9f70'

  def install
    system "make"
    bin.install "picocom"
  end
end
