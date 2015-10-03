class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.0/snap7-full-1.4.0.tar.gz"
  sha256 "5d2a4948a65e0ad2a52b1a7981f3c3209be0ef821f3d00756ee0584cf4b762bb"

  bottle do
    cellar :any
    sha256 "b8fa94cae36795dc754f17123317bd2e816f99907cecd2522e587ec52cbdb453" => :yosemite
    sha256 "d152d00966b20ae4429b3aabe53e91635bf2ee6125cae563778aefade1e59d0e" => :mavericks
    sha256 "ea1eeaee1876b4ef948cdef5b5f9b9a9b8233d93ffe285ad13fe1301100ca318" => :mountain_lion
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
