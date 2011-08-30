require 'formula'

class Tbb < Formula
  url 'http://www.threadingbuildingblocks.org/uploads/78/172/3.0%20update%208/tbb30_221oss_src.tgz'
  version '30_221'
  homepage 'http://www.threadingbuildingblocks.org/'
  sha1 '79c6b347f457e3176a5beae598a14b3a25bac4a0'

  def install
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on
    args = ['tbb_build_prefix=BUILDPREFIX']
    args << (MacOS.prefer_64_bit? ? "arch=intel64" : "arch=ia32")

    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end
