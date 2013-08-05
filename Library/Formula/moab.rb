require 'formula'

class Moab < Formula
  homepage 'https://trac.mcs.anl.gov/projects/ITAPS/wiki/MOAB'
  url 'https://bitbucket.org/fathomteam/moab/get/4.6.1.tar.gz'
  sha1 '6fad0bc6ff6c8c067edbfb56b5e7068c92a8e7cd'

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
