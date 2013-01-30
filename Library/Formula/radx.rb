require 'formula'

class Radx < Formula
  homepage 'http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html'
  url 'ftp://ftp.rap.ucar.edu/pub/titan/radx/Radx-20121120.src.tgz'
  version '20121120'
  sha1 '2c0ffa04c0f6b942fb2de1ec35256f857b5d2d63'

  depends_on 'hdf5'
  depends_on 'udunits'
  depends_on 'netcdf' => 'enable-cxx-compat'
  depends_on 'fftw'

  fails_with :clang do
    build 421
    cause "DsMdvx/msg_add.cc:516:11: error: '_printVsectWayPtsBuf' is a protected member of 'Mdvx'"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/RadxPrint", "-h"
  end
end
