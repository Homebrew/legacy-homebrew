require 'formula'

class Dterm < Formula
  url 'http://www.knossos.net.nz/downloads/dterm-0.3.tgz'
  homepage 'http://www.knossos.net.nz/dterm.html'
  md5 '4044341cf3b8e12559f8f25c9e428042'

  def install
    system "make"
    bin.install "dterm"
  end
end
