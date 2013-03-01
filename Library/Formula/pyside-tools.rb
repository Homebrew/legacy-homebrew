require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "lib/#{which_python}/site-packages"
end

class PysideTools < Formula
  homepage 'http://www.pyside.org'
  url 'http://qt-project.org/uploads/pyside/pyside-tools-0.2.14.tar.bz2'
  sha1 'f654553bc9bfb35dbc5673da26830969393f9fe8'

  depends_on 'cmake' => :build

  depends_on 'pyside'

  def install
    system "cmake", ".", "-DSITE_PACKAGE=#{site_package_dir}", *std_cmake_args
    system "make install"
  end
end
