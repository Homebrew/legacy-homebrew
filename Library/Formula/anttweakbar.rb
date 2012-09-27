require 'formula'

class Anttweakbar < Formula
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  url 'http://www.antisphere.com/Tools/AntTweakBar/AntTweakBar_114.zip'
  version '1.14'
  sha1 'b6405082efb6d6f26b3856a1b12c4e520055390e'

  def install
    cd 'src' do
      system 'make -f Makefile.osx'
    end
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end
