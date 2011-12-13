require 'formula'

class Dirbrowser < Formula
  url 'https://github.com/bend/Dir_browser/tarball/v0.4'
  homepage 'http://bend.github.com/Dir_browser/'
  md5 '38e9b47ab91999eba41e6910c32560a4'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
