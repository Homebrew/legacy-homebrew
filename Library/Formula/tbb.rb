require 'formula'

class Tbb < Formula
  url 'http://threadingbuildingblocks.org/uploads/78/166/3.0%20update%206/tbb30_174oss_src.tgz'
  version '30_174'
  homepage 'http://www.threadingbuildingblocks.org/'
  md5 'ee8f2e3ac3c6fef6f822ff346707e4c6'

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
