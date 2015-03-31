require "formula"

class Snap7 < Formula
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.3.0/snap7-full-1.3.0.tar.gz"
  sha1 "341e8678d2e3e818296ec054c78b740cce182c0e"

  bottle do
    cellar :any
    sha1 "89adc1a116219fccee8f6cc8c9bdb1632afa7069" => :mavericks
    sha1 "6293333e1262e08b0d9ba4eeda2b8cf16d1396d3" => :mountain_lion
    sha1 "66e715df7e668c98c000b778e4f820eb69637f1f" => :lion
  end

  def install
    lib.mkpath
    system "make", "-C", "build/osx",
                   "-f", "#{MacOS.preferred_arch}_osx.mk",
                   "install", "LibInstall=#{lib}"
    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    system "python", "-c", "import ctypes.util,sys;ctypes.util.find_library('snap7') or sys.exit(1)"
  end
end
