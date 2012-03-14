require 'formula'

class Anttweakbar < Formula
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  url 'http://www.antisphere.com/Tools/AntTweakBar/AntTweakBar_114.zip'
  version '1.14'
  md5 '2cb5f2fb7b3089f91521f4c14b726f8f'

  def install
    cd 'src' do
      system 'make -f Makefile.osx'
    end
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end
