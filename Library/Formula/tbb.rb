require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20140122oss_src.tgz'
  sha1 'd897a6ced4f425c6608422a2e19218898e727260'
  version '4.2.3'

  option :cxx11

  fails_with :llvm do
    cause 'llvm is not supported on macos. Add build/macos.llvm.inc file with compiler-specific settings.'
  end

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization
    ENV.cxx11 if build.cxx11?
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on, and use our compilers.
    compiler = ENV.compiler.to_s.start_with?('gcc') ? 'gcc' : ENV.compiler
    args = ['tbb_build_prefix=BUILDPREFIX',
            "compiler=#{compiler}"]
    args << (MacOS.prefer_64_bit? ? "arch=intel64" : "arch=ia32")
    args << "cpp0x=1" << "stdlib=libc++" if build.cxx11?
    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end
