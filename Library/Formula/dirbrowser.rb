require 'formula'

class Dirbrowser < Formula
  url 'https://github.com/bend/Dir_browser/tarball/v0.2'
  homepage 'http://bend.github.com/Dir_browser/'
  md5 '3f657350ae6b5cea1dfc8d6166dde6ca'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
