require 'formula'

class Pygments < Formula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.4.tar.gz'
  homepage 'http://pygments.org/'
  md5 'd77ac8c93a7fb27545f2522abe9cc462'

  depends_on 'python'

  def install
    system 'python setup.py config'
    system 'python setup.py build'
    system 'python setup.py install'
  end
end
