require 'formula'

class Treeline < Formula
  url 'http://download.berlios.de/treeline/treeline-1.2.4.tar.gz'
  homepage 'http://treeline.bellz.org/'
  md5 'af51957700b68c4af36dc0b5cf0fee92'

  depends_on 'pyqt'

  def install
    ENV.prepend "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python"
    system "./install.py", "-p#{prefix}"
  end
end
