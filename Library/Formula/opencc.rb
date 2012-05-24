require 'formula'

class Opencc < Formula
  url 'http://opencc.googlecode.com/files/opencc-0.3.0.tar.gz'
  homepage 'http://code.google.com/p/opencc/'
  md5 '84462870e5d491da24bb33a5fb494911'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
