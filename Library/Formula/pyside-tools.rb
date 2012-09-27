require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "lib/#{which_python}/site-packages"
end

class PysideTools < Formula
  homepage 'http://www.pyside.org'
  url 'http://www.pyside.org/files/pyside-tools-0.2.13.tar.bz2'
  sha1 '4d05444300331518c3b66536aec3048454db3380'

  depends_on 'cmake' => :build

  depends_on 'pyside'

  def install
    system "cmake", ".", "-DSITE_PACKAGE=#{site_package_dir}", *std_cmake_args
    system "make install"
  end
end
