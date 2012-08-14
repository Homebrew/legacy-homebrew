require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

def no_cxx?
  ARGV.include? '--disable-cxx'
end


class NetcdfCXX < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.2.tar.gz'
  sha1 '59628c9f06c211a47517fc00d8b068da159ffa9d'
end

class NetcdfFortran < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.2.tar.gz'
  sha1 'f1887314455330f4057bc8eab432065f8f6f74ef'
end

class Netcdf < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.2.1.tar.gz'
  sha1 'dfb6b10ef8dd20e785efa5e29b448383090f144d'

  depends_on 'hdf5'

  def options
    [
      ['--enable-fortran', 'Compile Fortran bindings'],
      ['--disable-cxx', "Don't compile C++ bindings"],
      ['--enable-largefiles', "For use with ExodusII LargeFile format"]
    ]
  end
  
  def patches
    if ARGV.include? "--enable-largefiles"
      #This patch edits netcdf.h to be compliant with the "LargeFile"
      #format required by ExodusII
      DATA
    end
  end

  def install
    if fortran?
      ENV.fortran
      # fix for ifort not accepting the --force-load argument, causing
      # the library libnetcdff.dylib to be missing all the f90 symbols.
      # http://www.unidata.ucar.edu/software/netcdf/docs/known_problems.html#intel-fortran-macosx
      # https://github.com/mxcl/homebrew/issues/13050
      ENV['lt_cv_ld_force_load'] = 'no' if ENV['FC'] == 'ifort'
    end


    common_args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
      --enable-shared
    ]


    args = common_args.clone
    args.concat %w[--enable-netcdf4 --disable-doxygen]

    system './configure', *args
    system 'make install'

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    ENV.prepend 'PATH', bin, ':'
    ENV.prepend 'CPPFLAGS', "-I#{include}"
    ENV.prepend 'LDFLAGS', "-L#{lib}"

    NetcdfCXX.new.brew do
      system './configure', *common_args
      system 'make install'
    end unless no_cxx?

    NetcdfFortran.new.brew do
      system './configure', *common_args
      system 'make install'
    end if fortran?
  end
end

__END__
diff --git a/include/netcdf.h b/include/netcdf.h
index 8ccfb0f..0353b29 100644
--- a/include/netcdf.h
+++ b/include/netcdf.h
@@ -189,11 +189,11 @@ created with the ::NC_CLASSIC_MODEL flag.
 As a rule, NC_MAX_VAR_DIMS <= NC_MAX_DIMS.
 */
 /**@{*/
-#define NC_MAX_DIMS	1024	
+#define NC_MAX_DIMS	65536
 #define NC_MAX_ATTRS	8192	
-#define NC_MAX_VARS	8192	
+#define NC_MAX_VARS	524288
 #define NC_MAX_NAME	256	
-#define NC_MAX_VAR_DIMS	1024 /**< max per variable dimensions */
+#define NC_MAX_VAR_DIMS	8 /**< max per variable dimensions */
 /**@}*/
 
 /** This is the max size of an SD dataset name in HDF4 (from HDF4 documentation).*/
