require 'formula'

class PysideTools < Formula
  homepage 'http://www.pyside.org'
  url 'https://github.com/PySide/Tools/archive/0.2.15.tar.gz'
  sha1 'b668d15e8d67e25a653db5abf8f542802e2ee2dd'

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
