require 'formula'

class H5utils < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/H5utils'
  url 'http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz'
  sha1 '1bd8ef8c50221da35aafb5424de9b5f177250d2d'

  depends_on 'hdf5'
  depends_on :x11

  # A patch is required in order to build h5utils with libpng 1.5
  # as described by https://github.com/mxcl/homebrew/pull/6944
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking","--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/writepng.c b/writepng.c
index 33990d9..25336ce 100644
--- a/writepng.c
+++ b/writepng.c
@@ -309,7 +309,7 @@ void writepng(char *filename,
      }
      /* Set error handling.  REQUIRED if you aren't supplying your own *
       * error hadnling functions in the png_create_write_struct() call. */
-     if (setjmp(png_ptr->jmpbuf)) {
+     if (setjmp(png_jmpbuf (png_ptr))) {
 	  /* If we get here, we had a problem reading the file */
 	  fclose(fp);
 	  png_destroy_write_struct(&png_ptr, (png_infopp) NULL);
@@ -434,7 +434,7 @@ void writepng(char *filename,
      png_write_end(png_ptr, info_ptr);
 
      /* if you malloced the palette, free it here */
-     free(info_ptr->palette);
+     /* free(info_ptr->palette); */
 
      /* if you allocated any text comments, free them here */
 
