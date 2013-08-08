require 'formula'

class PysideTools < Formula
  homepage 'http://www.pyside.org'
  url 'http://qt-project.org/uploads/pyside/pyside-tools-0.2.14.tar.bz2'
  sha1 'f654553bc9bfb35dbc5673da26830969393f9fe8'

  head 'git://gitorious.org/pyside/pyside-tools.git'

  depends_on 'cmake' => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'pyside'

  def install
    python do
      args = std_cmake_args
      args << "-DSITE_PACKAGE=#{python.site_packages}"
      # The next two lines are because pyside needs this to switch Python
      # versions in HOMEBREW_PREFIX/lib/cmake/PySide-X.Y.Z/PySideConfig.cmake
      args << "-DPYTHON_BASENAME=-python2.7" if python2
      args << "-DPYTHON_BASENAME=.cpython-33m" if python3
      # And these two lines are because the ShibokenConfig.cmake needs this to
      # switch python versions. The price for supporting both versions:
      args << "-DPYTHON_SUFFIX='-python2.7'" if python2
      args << "-DPYTHON_SUFFIX='.cpython-33m'" if python3
      system "cmake", ".", *args
      system "make install"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
