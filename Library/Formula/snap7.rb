require "formula"

class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.3.0/snap7-full-1.3.0.tar.gz"
  sha1 "341e8678d2e3e818296ec054c78b740cce182c0e"

  bottle do
    cellar :any
    sha256 "9b3b9fbef28833a9d147f0188f157d6c5f7ccf15e1dcacbbf0da49d356e8d532" => :yosemite
    sha256 "dc9f328d48db101c5982be8bdfbbc71894215f07c695e6f1b59a9ed3eeea4752" => :mavericks
    sha256 "c1917deec7552252498d192c4c05fe4e569cff8d2058756bcc04d92504ed356a" => :mountain_lion
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
