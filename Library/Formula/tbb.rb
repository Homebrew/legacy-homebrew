require 'formula'

class Tbb < Formula
  url 'http://threadingbuildingblocks.org/uploads/77/177/4.0%20update%201/tbb40_20111003oss_src.tgz'
  version '4.0u1'
  homepage 'http://www.threadingbuildingblocks.org/'
  sha1 '1155b2fa6d5f2f92a766ca7919951992d37c1e08'

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
