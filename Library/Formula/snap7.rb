require "formula"

class Snap7 < Formula
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.2.1/snap7-full-1.2.1.tar.gz"
  sha1 "1e661fea17c26586599c11a1a840f4ac013060b6"

  def install
    archstr = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    lib.mkpath

    Dir.chdir "build/osx" do
      system "make", "-f", "#{archstr}_osx.mk", "install", "LibInstall=#{lib}"
    end

    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    system "python", "-c", "import ctypes.util,sys;ctypes.util.find_library('snap7') or sys.exit(1)"
  end
end
