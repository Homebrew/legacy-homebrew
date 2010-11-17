require 'formula'

class Jpeg6 <Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/jpeg/src/jpegsrc.v6b.tar.gz'
  md5 '83992a9466af7536da30efe6b51d4064'
  version '6b'
  homepage 'http://www.ijg.org/'
end

class Hdf4 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.5.tar.gz'
  md5 '7241a34b722d29d8561da0947c06069f'
  homepage 'http://www.hdfgroup.org'

  depends_on "szip"

  def install
    jpeg_dir = Pathname.new( Dir.pwd ) + 'jpeg6'

    Jpeg6.new.brew do
      system "./configure", "--disable-shared"
      system "make"

      jpeg_lib = jpeg_dir + "lib"
      jpeg_include = jpeg_dir + "include"

      jpeg_lib.install Dir['*.a']
      jpeg_include.install Dir['*.h']
    end

    hdf_stage = Pathname.new( Dir.pwd ) + 'build'

    system "./configure", "--prefix=#{hdf_stage}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-production",
                          "--disable-netcdf",
                          "--disable-shared",
                          "--with-jpeg=#{jpeg_dir}",
                          "--with-szlib=#{HOMEBREW_PREFIX}"

    system "make install"

    Dir.chdir hdf_stage do
      # We only install libs and includes.  Due to the age of this code, all
      # binaries want to use JPEG as a dynamic dependency--- but they get a
      # system library that is much newer than expected.  Also, for some strange
      # reason HDF4 builds the `ncdump` and `ncgen` utilities even though
      # `--disable-netcdf` was passed to configure.  Therefore, installing the
      # bin folder is dangerous.
      lib.install Dir['lib/*']
      include.install Dir['include/*']
    end
  end

  def caveats
    caveats <<-EOS.undent
      HDF4 has been superseeded by HDF5.  However some programs still require
      the HDF4 libraries in order to function.  This formula provides a keg-only
      installation of the HDF4 static libraries and header files so that they
      may be used to build other pieces of software that provide or require
      legacy support for HDF4.
    EOS
  end
end
