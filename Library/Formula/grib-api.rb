require 'formula'

class GribApi < Formula
  homepage 'https://software.ecmwf.int/wiki/display/GRIB/Home'
  url 'https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.9.16.tar.gz'
  sha1 'baff7ad8de71d5e81a90595a0b4650c77f8bd6cf'

  depends_on 'jasper' => :recommended
  depends_on 'openjpeg' => :optional

  # Fixes undefined symbols _stdio_read with clang. Patch from Fink.
  def patches; DATA; end

  def install
    ENV.deparallelize
    ENV.no_optimization
    ENV.fortran

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
--- a/src/grib_io.c	2012-03-06 10:00:51.000000000 -0800
+++ b/src/grib_io.c	2012-10-16 10:47:44.000000000 -0700
@@ -548,19 +548,19 @@

 }

-GRIB_INLINE off_t stdio_tell(void* data) {
+GRIB_INLINE static off_t stdio_tell(void* data) {
	FILE* f = (FILE*)data;
	return ftello(f);
 }

-GRIB_INLINE int stdio_seek(void* data,off_t len) {
+GRIB_INLINE static int stdio_seek(void* data,off_t len) {
	FILE* f = (FILE*)data;
	int err=0;
	if (fseeko(f,len,SEEK_CUR)) err=GRIB_IO_PROBLEM;
	return err;
 }

-GRIB_INLINE int stdio_read(void* data,void* buf,int len,int* err)
+GRIB_INLINE static int stdio_read(void* data,void* buf,int len,int* err)
 {
	FILE* f = (FILE*)data;
	int n;
--- a/src/grib_api_prototypes.h	2012-03-06 10:00:51.000000000 -0800
+++ b/src/grib_api_prototypes.h	2012-10-16 10:49:35.000000000 -0700
@@ -785,9 +785,9 @@
 int grib_hash_keys_get_size(grib_itrie *t);

 /* grib_io.c */
-GRIB_INLINE off_t stdio_tell(void *data);
-GRIB_INLINE int stdio_seek(void *data, off_t len);
-GRIB_INLINE int stdio_read(void *data, void *buf, int len, int *err);
+GRIB_INLINE static off_t stdio_tell(void *data);
+GRIB_INLINE static int stdio_seek(void *data, off_t len);
+GRIB_INLINE static int stdio_read(void *data, void *buf, int len, int *err);
 int wmo_read_any_from_file(FILE *f, void *buffer, size_t *len);
 int wmo_read_grib_from_file(FILE *f, void *buffer, size_t *len);
 int wmo_read_bufr_from_file(FILE *f, void *buffer, size_t *len);
