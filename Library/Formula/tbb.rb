require 'formula'

class Tbb < Formula
  url 'http://threadingbuildingblocks.org/uploads/77/180/4.0%20update%202/tbb40_20111130oss_src.tgz'
  version '4.0u2'
  homepage 'http://www.threadingbuildingblocks.org/'
  sha1 '33bc0bb2f17386d21ccb4b0c3c93a115f68a8a08'

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
