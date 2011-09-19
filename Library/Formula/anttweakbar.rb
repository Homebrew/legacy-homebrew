require 'formula'

class Anttweakbar < Formula
  url 'http://www.antisphere.com/Tools/AntTweakBar/AntTweakBar_114.zip'
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  md5 '2cb5f2fb7b3089f91521f4c14b726f8f'

  def install
    system 'cd src; make -f Makefile.osx'
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end
