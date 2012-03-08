require 'formula'

class Numpy < Formula
  homepage 'http://numpy.scipy.org/'
  url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.6.1/numpy-1.6.1.tar.gz'
  md5 '2bce18c08fc4fce461656f0f4dd9103e'

  # Patch per discussion at: http://projects.scipy.org/numpy/ticket/1926
  def patches
    "https://github.com/numpy/numpy/commit/073bc39c58a6788ffda6aaa7549955cc3d4fdc93.patch"
  end

  def install
    system "python", "setup.py", "build",
                     "--fcompiler=gnu95"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    system "python -c 'import numpy; numpy.test()'"
  end
end
