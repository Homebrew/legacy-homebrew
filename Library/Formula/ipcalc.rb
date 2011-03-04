require 'formula'

class Ipcalc <Formula
  url 'http://jodies.de/ipcalc-archive/ipcalc-0.41.tar.gz'
  homepage 'http://jodies.de/ipcalc'
  md5 'fb791e9a5220fc8e624d915e18fc4697'

  def install
    bin.install "ipcalc"
  end
end
