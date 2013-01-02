require 'formula'

class Opencc < Formula
  url 'http://opencc.googlecode.com/files/opencc-0.3.0.tar.gz'
  homepage 'http://code.google.com/p/opencc/'
  sha1 '76f1750751b7fe15d25d66f0378814434fad1e70'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
