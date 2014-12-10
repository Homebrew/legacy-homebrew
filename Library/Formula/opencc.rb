require 'formula'

class Opencc < Formula
  homepage 'https://github.com/BYVoid/OpenCC'
  url 'https://opencc.googlecode.com/files/opencc-0.4.3.tar.gz'
  sha1 '4677e63fa36fb2b92a52c01df2acc83664aaf882'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << '-DENABLE_GETTEXT:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
