require 'formula'

class Treeline < Formula
  homepage 'http://treeline.bellz.org/'
  url 'http://sourceforge.net/projects/treeline/files/1.4.1/treeline-1.4.1.tar.gz'
  sha1 'ac5ef60fbb02e2295868134b8e3068c2f905c170'

  depends_on 'pyqt'

  def install
    ENV.prepend "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python"
    system "./install.py", "-p#{prefix}"
  end
end
