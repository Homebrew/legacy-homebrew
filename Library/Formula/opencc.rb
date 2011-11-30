require 'formula'

class Opencc < Formula
  url 'http://opencc.googlecode.com/files/opencc-0.2.0.tar.gz'
  homepage 'http://code.google.com/p/opencc/'
  md5 'fc5915f43f7bd30f0f30ccdc4ad3a7f1'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_parameters.split
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
