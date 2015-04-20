require 'formula'

class Montage < Formula
  homepage 'http://montage.ipac.caltech.edu'
  url 'http://montage.ipac.caltech.edu/download/Montage_v3.3.tar.gz'
  sha1 'c8db5b9018c96e19b584d45758819e892b453d6d'

  def install
    system "make"
    bin.install Dir['bin/m*']
  end

  # fix function not being declared void
  patch :DATA

  def caveats; <<-EOS.undent
    Montage is under the Caltech/JPL non-exclusive, non-commercial software
    licence agreement available at:
      http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end
end

__END__
diff --git a/lib/src/two_plane_v1.1/initdistdata.c b/lib/src/two_plane_v1.1/initdistdata.c
index 0a75b24..8c1b9bb 100644
--- a/lib/src/two_plane_v1.1/initdistdata.c
+++ b/lib/src/two_plane_v1.1/initdistdata.c
@@ -21,7 +21,7 @@ int openfitsfile(char *fitsfilename)
   return 0;
 }
 
-closefitsfile()
+void closefitsfile()
 { 
   int I_fits_return_status=0;
   fits_close_file(ffp_FITS_In, &I_fits_return_status); 
