require 'formula'

class Tbb <Formula
  url 'http://threadingbuildingblocks.org/uploads/77/164/3.0%20Update%205/tbb30_20101215oss_src.tgz'
  version '30_131'
  homepage 'http://www.threadingbuildingblocks.org/'
  md5 'd1f65b7ba8bafda5a8616dfc8159ea05'

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
