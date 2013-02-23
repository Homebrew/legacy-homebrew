require 'formula'

class Ipcalc < Formula
  homepage 'http://jodies.de/ipcalc'
  url 'http://jodies.de/ipcalc-archive/ipcalc-0.41.tar.gz'
  sha1 'b75b498f2fa5ecfa30707a51da63c6a5775829f3'

  def install
    bin.install "ipcalc"
  end
end
