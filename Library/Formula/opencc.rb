require 'formula'

class Opencc < Formula
  homepage 'https://github.com/BYVoid/OpenCC'
  url 'http://opencc.googlecode.com/files/opencc-0.4.2.tar.gz'
  sha1 '1e4216e5fe21b16836063f23d0341cb54dbce97c'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
