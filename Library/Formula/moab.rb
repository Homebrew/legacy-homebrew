require 'formula'

class Moab < Formula
  homepage 'https://trac.mcs.anl.gov/projects/ITAPS/wiki/MOAB'
  url 'https://bitbucket.org/fathomteam/moab/get/master.tar.gz'
  sha1 'cc03c46938d053095082dc7af0ad82b1cc3c06d7'

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
