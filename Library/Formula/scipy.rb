require 'formula'

class Scipy < Formula
  url 'http://downloads.sourceforge.net/project/scipy/scipy/0.9.0/scipy-0.9.0.tar.gz'
  homepage 'http://www.scipy.org/'
  md5 'ebfef6e8e82d15c875a4ee6a46d4e1cd'

  depends_on 'python'
  depends_on 'numpy'
  depends_on 'suite-sparse'

  def install
    ENV.fortran
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install"
  end
end
