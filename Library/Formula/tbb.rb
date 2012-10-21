require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'http://threadingbuildingblocks.org/uploads/77/187/4.0%20update%205/tbb40_20120613oss_src.tgz'
  sha1 '48569b88450a78e8f1e7251500fdd951bb197f1b'
  version '4.0u5'

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
