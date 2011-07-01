require 'formula'

class Grads < Formula
  url 'ftp://iges.org/grads/2.0/grads-2.0.a9-bin-darwin9.8-intel.tar.gz'
  homepage 'http://www.iges.org/grads/grads.html'
  md5 '9c9f054aa2f96562fc49771f6364aeab'
  version '2.0a9'

  depends_on 'grads-supplementary'

  def install
    bin.install ['bin/bufrscan', 'bin/grads', 'bin/grib2scan', 'bin/gribmap', 'bin/gribscan', 'bin/gxeps', 'bin/gxps', 'bin/gxtran', 'bin/stnmap', 'bin/wgrib']
  end
end
