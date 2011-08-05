require 'formula'

class Ipython < Formula
  url 'http://archive.ipython.org/release/0.11/ipython-0.11.tar.gz'
  homepage 'http://ipython.org/'
  md5 'efc899e752a4a4a67a99575cea1719ef'

  depends_on 'python'
  depends_on 'pygments'
  depends_on 'readline'

  def install
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install"
  end
end
