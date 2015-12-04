class Horndis < Formula
  desc "USB tethering driver for OS X"
  homepage "http://joshuawise.com/horndis"
  url "https://github.com/jwise/HoRNDIS/archive/rel7.tar.gz"
  sha256 "62963e3c4e7fc81f3babd6843e516fde682f5065730d6eb62dc58480719917cd"

  bottle do
    cellar :any
    sha256 "8136b66d019783935531913b7bc02df915ecd03abae73e4d00f660b9e2a6692c" => :mavericks
    sha256 "c93a78b2b24a01c83e061965831e0f5652919a00fc5ee77a01865ebb893a21fb" => :mountain_lion
  end

  depends_on UnsignedKextRequirement
  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SDKROOT=",
                                            "MACOSX_DEPLOYMENT_TARGET=",
                                            "GCC_VERSION=",
                                            "ONLY_ACTIVE_ARCH=YES",
                                            "SYMROOT=build"
    kext_prefix.install "build/Release/HoRNDIS.kext"
  end

  def caveats; <<-EOS.undent
    In order for HoRNDIS to work, kernel extension must be installed by the root user:
    $ sudo /bin/cp -rfX #{kext_prefix}/HoRNDIS.kext /Library/Extensions
    EOS
  end
end
