require 'formula'

class Gdal <Formula
  url 'http://download.osgeo.org/gdal/gdal-1.6.3.tar.gz'
  homepage 'http://www.gdal.org/'
  md5 'a8aade344a29ae4a92a0f17cc33f561a'

  depends_on 'libtiff'
  depends_on 'giflib'
  depends_on 'proj'
  depends_on 'geos'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-pthreads",
                          "--with-local=#{prefix}",
                          "--with-png=/usr/X11",
                          "--without-pg",
                          "--without-grass",
                          "--without-libgrass",
                          "--without-cfitsio",
                          "--without-pcraster",
                          "--without-netcdf",
                          "--without-ogdi",
                          "--without-fme",
                          "--without-hdf4",
                          "--without-hdf5",
                          "--without-jasper",
                          "--without-ecw",
                          "--without-kakadu",
                          "--without-mrsid",
                          "--without-jp2mrsid",
                          "--without-msg",
                          "--without-bsb",
                          "--without-oci",
                          "--without-grib",
                          "--without-mysql",
                          "--without-ingres",
                          "--without-xerces",
                          "--without-expat",
                          "--without-odbc",
                          "--with-dods-support=no",
                          "--without-curl",
                          "--without-sqlite3",
                          "--without-dwgdirect",
                          "--without-idb",
                          "--without-sde",
                          #"--without-geos",
                          "--without-pam",
                          "--without-macosx-framework",
                          "--without-perl",
                          "--without-php",
                          #"--without-ruby",
                          #"--without-python",
                          "--without-ogpython",
                          "--without-xerces"
    system "make"
    system "make install"
  end
end
