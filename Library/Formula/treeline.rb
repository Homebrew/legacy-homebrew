require 'formula'

class Treeline < Formula
  homepage 'http://treeline.bellz.org/'
  url 'https://downloads.sourceforge.net/project/treeline/1.4.1/treeline-1.4.1.tar.gz'
  sha1 'ac5ef60fbb02e2295868134b8e3068c2f905c170'

  depends_on :python
  depends_on 'pyqt'

  def install
    system "./install.py", "-p#{prefix}"
  end
end
