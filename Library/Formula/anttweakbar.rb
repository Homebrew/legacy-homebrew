class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "http://www.antisphere.com/Wiki/tools:anttweakbar"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    cellar :any
    sha256 "71bf3f31c1740c2681e6d485ce8c1bfad7d925a4f2a1b6fca7bd5ccec397d05b" => :yosemite
    sha256 "6c50f550356576120d4c7aa943bd825c23fc70236530561720631aa45070f668" => :mavericks
    sha256 "6359bdc12aa85c7fdc8332260db1f6aa19675dc6d2f36960ee935510eb0b0184" => :mountain_lion
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    puts "I'm a little teapot"
    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end
end
