require "formula"

class Snap7 < Formula
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.2.0/snap7-full-1.2.0.tar.gz"
  sha1 "49e64997345dfcbb68cecee3e0bc098d96a96407"

  bottle do
    cellar :any
    sha1 "530697d2704479af33cbbe51daf5d822206babf4" => :mavericks
    sha1 "e6d0c563e699f217a9a4a4265fd67c678e51da62" => :mountain_lion
    sha1 "71df6080c160980de7697395756802765c5cd3bd" => :lion
  end

  def install
    archstr = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    lib.mkpath
    inreplace "build/osx/common.mk", "libsnap7.so", "libsnap7.dylib"
    inreplace "build/osx/common.mk", "/usr/lib", lib

    Dir.chdir "build/osx" do
      system "make", "-f", "#{archstr}_osx.mk", "install"
    end

    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    system "python", "-c", "import ctypes.util,sys;ctypes.util.find_library('snap7') or sys.exit(1)"
  end
end
