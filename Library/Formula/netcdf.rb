require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Netcdf < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.2.1.1.tar.gz'
  sha1 '76631cb4e6b767c224338415cf6e5f5ff9bd1238'

  depends_on 'hdf5'

  def patches
      # makes appropriate changes for "LargeFile format" required by ExodusII
      DATA
  end

  def install

    common_args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
      --enable-shared
    ]
  
    args = common_args.clone
    args.concat %w[--enable-netcdf4 --disable-doxygen]

    system "./configure", *args
    system "make install"

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
