class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "http://www.antisphere.com/Wiki/tools:anttweakbar"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    cellar :any
    revision 1
    sha256 "417278abe012967efcf22b0276527187f6472dd5fd4d271b1ea32604816d46c9" => :el_capitan
    sha256 "a2e29104a5ef51621faaebd72ccc39bd5fe7bd6e977af74a358c5cc83c65c2c2" => :yosemite
    sha256 "d1298b92cf6a7498c3b357adf6e696d0b24374e758853783fa228a8af5eecddc" => :mavericks
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end
end
