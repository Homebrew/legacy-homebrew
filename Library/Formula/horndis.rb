require "formula"

class Horndis < Formula
  homepage "http://joshuawise.com/horndis"
  url "https://github.com/jwise/HoRNDIS/archive/rel5.tar.gz"
  sha1 "5f01c62ae61554252c0fe727e414edcb8e060106"

  depends_on :xcode

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
