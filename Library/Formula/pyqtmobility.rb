require 'formula'

class PyQtMobility < Formula
  homepage 'http://www.riverbankcomputing.com/software/pyqtmobility/intro'
  url 'http://www.riverbankcomputing.com/static/Downloads/PyQtMobility/PyQtMobility-gpl-1.0.1.tar.gz'
  sha1 '996dbe601ab54ec1876022cb9c59e5f8a3a9074f'
  
  depends_on :python => :recommended
  depends_on :python3 => :optional

  depends_on 'pyqt'
  depends_on 'qt-mobility'
  
  option 'trace', 'Build the QtMobility modules with tracing enabled'
  option 'debug', 'Build the QtMobility modules with debugging symbols'
  option 'no-docstrings', 'Disable the generation of docstrings'

  def install
    python do
      args = []
      args << '-r' if build.include? 'trace'
      args << '-u' if build.include? 'debug'
      args << '--no-docstrings' if build.include? 'no-docstrings'
      
      system python, "configure.py", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
