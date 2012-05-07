require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'http://threadingbuildingblocks.org/uploads/77/185/4.0%20update%204/tbb40_20120408oss_src.tgz'
  sha1 '04390147d40b86ae6291a9971a9c8afd327db718'
  version '4.0u4'

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on, and use our compilers.
    args = ['tbb_build_prefix=BUILDPREFIX',
            "CONLY=#{ENV.cc}",
            "CPLUS=#{ENV.cxx}"]
    args << (MacOS.prefer_64_bit? ? "arch=intel64" : "arch=ia32")
    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end
