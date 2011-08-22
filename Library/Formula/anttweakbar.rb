require 'formula'

class Anttweakbar < Formula
  url 'http://www.antisphere.com/Tools/AntTweakBar/AntTweakBar_114.zip'
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  md5 '5aaee2ea2bca03a258f8dad494828d7e'

  depends_on 'cmake'
  depends_on 'dos2unix'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def patches
    # this was developed by a windows guy (apparently); need to run dos2unix
    # in order to apply a patch
    system "dos2unix `find src/ -type f`"

    # add build infrastructure (cmake), and patch a few 10.7 issues
    "https://raw.github.com/gist/1163244/fc972c607502fdc088e765a9b6ecde0122566777/atb_patch.diff"
  end
end
