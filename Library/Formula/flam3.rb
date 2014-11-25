require "formula"

class Flam3 < Formula
  homepage "http://code.google.com/p/flam3/"
  url "https://flam3.googlecode.com/files/flam3-3.0.1.tar.gz"
  sha1 "8814515f2e49e034e47cf97e9d2c0e932844abb9"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng12"
  depends_on "jpeg"

  # patch to avoid seg fault (cfr https://code.google.com/p/flam3/issues/detail?id=10)
  patch :DATA

  def install
    ENV.append 'LDFLAGS', "-L/usr/local/opt/libpng12/lib"
    ENV.append 'CPPFLAGS', "-L/usr/local/opt/libpng12/include"

    Dir.chdir("src")
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "test -x #{bin}/flam3-render"
  end
end

__END__
# patch starts here
diff --git a/src/rect.c b/src/rect.c
index 4704f48..aa4d4eb 100644
--- a/src/rect.c
+++ b/src/rect.c
@@ -559,7 +559,6 @@ static int render_rectangle(flam3_frame *spec, void *out,
    pthread_attr_t pt_attr;
    pthread_t *myThreads=NULL;
 #endif
-   int thread_status;
    int thi;
    time_t tstart,tend;   
    double sumfilt;
@@ -894,7 +893,7 @@ static int render_rectangle(flam3_frame *spec, void *out,
 
          /* Wait for them to return */
          for (thi=0; thi < spec->nthreads; thi++)
-            pthread_join(myThreads[thi], (void **)&thread_status);
+            pthread_join(myThreads[thi], (void **)0);
 
          #if defined(USE_LOCKS)
          pthread_mutex_destroy(&fic.bucket_mutex);
@@ -1025,7 +1024,7 @@ static int render_rectangle(flam3_frame *spec, void *out,
 
          /* Wait for them to return */
          for (thi=0; thi < spec->nthreads; thi++)
-            pthread_join(myThreads[thi], (void **)&thread_status);
+            pthread_join(myThreads[thi], (void **)0);
          
          free(myThreads);            
 #else         
