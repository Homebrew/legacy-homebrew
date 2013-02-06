require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'http://threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb41_20121003oss_src_1.tgz'
  sha1 '9ecf581dbf98f7828d83b4f1b47f6f1140fbb759'
  version '4.1u1'

  fails_with :clang do
    build 425
    cause "Undefined symbols for architecture x86_64: vtable for tbb::tbb_exception"
  end

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
