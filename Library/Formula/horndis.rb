require "formula"

class Horndis < Formula
  homepage "http://joshuawise.com/horndis"
  url "https://github.com/jwise/HoRNDIS/archive/rel5.tar.gz"
  sha1 "5f01c62ae61554252c0fe727e414edcb8e060106"

  bottle do
    cellar :any
    sha1 "a62c0ae0ac89d307437735c910db3ad5a2118683" => :mavericks
    sha1 "c8109415f6ab8ecede83c9614ed561b3072343aa" => :mountain_lion
    sha1 "e5537e2ba72e129c846d962ab8b45c44878bab5a" => :lion
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
