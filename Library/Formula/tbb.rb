require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'http://threadingbuildingblocks.org/uploads/77/189/4.1%20update%201/tbb41_20121003oss_src.tgz'
  sha1 '55dc1684eefe7933955c9fe89313267de548a2aa'
  version '4.1u1'

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
