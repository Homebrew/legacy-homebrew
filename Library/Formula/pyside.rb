require 'formula'

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'http://qt-project.org/uploads/pyside/pyside-qt4.8+1.1.2.tar.bz2'
  mirror 'https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.1.2.tar.bz2'
  sha1 'c0119775f2500e48efebdd50b7be7543e71b2c24'

  depends_on 'cmake' => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.with? 'python3'
    depends_on 'shiboken' => 'with-python3'
  else
    depends_on 'shiboken'
  end

  depends_on 'qt'

  def install
    python do
      # Add out of tree build because one of its deps, shiboken, itself needs an
      # out of tree build in shiboken.rb.
      mkdir "macbuild#{python.if3then3}" do
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/#{python.xy}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{Formula.factory('qt').frameworks}
          -DBUILD_TESTS=NO
          ..
        ]
        # The next two lines are because shiboken needs them
        args << "-DPYTHON_SUFFIX='-python2.7'" if python2
        args << "-DPYTHON_SUFFIX='.cpython-33m'" if python3
        system 'cmake', *args
        system 'make'
        system 'make install'
        # Todo: How to deal with pyside.pc file? It doesn't support 2.x and 3.x!
      end
    end
  end

  def test
    system 'python', '-c', "from PySide import QtCore" if Tab.for_formula('Pyside').with? 'python'
    system 'python3', '-c', "from PySide import QtCore" if Tab.for_formula('Pyside').with? 'python3'
  end

  def caveats
    python.standard_caveats if python
  end
end
