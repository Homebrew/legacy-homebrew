require 'formula'

class PysideTools < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage 'http://www.pyside.org'
  url 'https://github.com/PySide/Tools/archive/0.2.15.tar.gz'
  sha1 'b668d15e8d67e25a653db5abf8f542802e2ee2dd'

  head 'git://gitorious.org/pyside/pyside-tools.git'

  depends_on 'cmake' => :build
  depends_on 'pyside'

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make install"
  end
end
