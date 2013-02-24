require 'formula'

class Anttweakbar < Formula
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  url 'http://www.antisphere.com/Tools/AntTweakBar/AntTweakBar_115.zip'
  version '1.15'
  sha1 'fcc5069c00001e4954e2c465042f591df167c40b'

  def install
    cd 'src' do
      system 'make -f Makefile.osx'
    end
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end
