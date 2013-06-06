require 'formula'

class Anttweakbar < Formula
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  url 'http://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip'
  version '1.16'
  sha1 '5743321df3b074f9a82b5ef3e6b54830a715b938'

  def install
    cd 'src' do
      system 'make -f Makefile.osx'
    end
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end
