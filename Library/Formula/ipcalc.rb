require 'formula'

class Ipcalc < Formula
  url 'http://jodies.de/ipcalc-archive/ipcalc-0.41.tar.gz'
  homepage 'http://jodies.de/ipcalc'
  sha1 'b75b498f2fa5ecfa30707a51da63c6a5775829f3'

  def install
    bin.install "ipcalc"
  end
end
