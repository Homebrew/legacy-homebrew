require 'formula'

class Moab < Formula
  homepage 'https://trac.mcs.anl.gov/projects/ITAPS/wiki/MOAB'
  url 'https://bitbucket.org/fathomteam/moab/get/4.6.0.tar.gz'
  sha1 '0224188f423ee0fde92af86b8ececa86850bad02'

  depends_on :automake
  depends_on :libtool
  depends_on 'netcdf'
  depends_on 'hdf5'

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
