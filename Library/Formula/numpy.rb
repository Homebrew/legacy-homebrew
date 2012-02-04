require 'formula'

class Numpy < Formula
  url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.6.1/numpy-1.6.1.tar.gz'
  homepage 'http://numpy.scipy.org/'
  md5 '2bce18c08fc4fce461656f0f4dd9103e'

  depends_on 'python'
  depends_on 'suite-sparse'

  def install
    ENV.fortran
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install"
  end
end
