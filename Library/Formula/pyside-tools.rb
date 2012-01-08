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
  md5 '14d3a36df06d680357d7bc1960f19a6d'

  depends_on 'cmake' => :build

  depends_on 'pyside'

  def install
    system "cmake . #{std_cmake_parameters} -DSITE_PACKAGE=#{site_package_dir}"
    system "make install"
  end
end
