require 'formula'

class Tbb < Formula
  homepage 'http://www.threadingbuildingblocks.org/'
  url 'https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20130725oss_src.tgz'
  sha1 'f354bd9b67295f65c43531b751e34f483ed8a024'
  version '4.2'

  fails_with :llvm do
    cause 'llvm is not supported on macos. Add build/macos.llvm.inc file with compiler-specific settings.'
  end

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on, and use our compilers.
    args = ['tbb_build_prefix=BUILDPREFIX',
            "compiler=#{ENV.compiler}"]
    args << (MacOS.prefer_64_bit? ? "arch=intel64" : "arch=ia32")
    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end
