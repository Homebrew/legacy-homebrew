require 'formula'

class Tbb < Formula
  url 'http://threadingbuildingblocks.org/uploads/78/170/3.0%20update%207/tbb30_196oss_src.tgz'
  version '30_196'
  homepage 'http://www.threadingbuildingblocks.org/'
  sha1 'eb77db011bc595d77a69de4fb78004b370cabd2f'

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
