require 'formula'

class Tbb <Formula
  url 'https://github.com/downloads/gmanley/homebrew/tbb-30_127.tgz'
  version '30_127'
  homepage 'http://www.threadingbuildingblocks.org/'
  md5 'c911f74f3d207358bb5554614b276c39'

  def install
    # Override build prefix so we can copy the dylibs out of the same place
    # no matter what system we're on
    args = ['tbb_build_prefix=BUILDPREFIX']
    args << (snow_leopard_64? ? "arch=intel64" : "arch=ia32")

    system "make", *args
    lib.install Dir['build/BUILDPREFIX_release/*.dylib']
    include.install 'include/tbb'
  end
end
