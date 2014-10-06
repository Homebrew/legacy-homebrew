require "formula"

class Horndis < Formula
  homepage "http://joshuawise.com/horndis"
  url "https://github.com/jwise/HoRNDIS/archive/rel6.tar.gz"
  sha1 "e41ed0c5c06ee555a4a418696b112c955a356ce0"

  bottle do
    cellar :any
    sha1 "e37bc2997a594e67eaeac3c0f8d1ff5f51da7d99" => :mavericks
    sha1 "1fb6c9910e96a67f34d48260d3d41ebeefb1749a" => :mountain_lion
    sha1 "af083937c77de9d628d9cf6858296be61846ad63" => :lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET=", "GCC_VERSION=", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    kext_prefix.install "build/Release/HoRNDIS.kext"
  end

  def caveats; <<-EOS.undent
    In order for HoRNDIS to work, kernel extension must be installed by the root user:
    $ sudo /bin/cp -rfX #{kext_prefix}/HoRNDIS.kext /Library/Extensions
    EOS
  end
end
