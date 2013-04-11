require 'formula'

class Opencc < Formula
  homepage 'http://code.google.com/p/opencc/'
  url 'http://opencc.googlecode.com/files/opencc-0.4.0.tar.gz'
  sha1 'b5521bbaa04dfc8294fc214144ce59801d31dae8'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
