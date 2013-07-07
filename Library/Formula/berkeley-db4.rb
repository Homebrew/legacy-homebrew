require 'formula'

class BerkeleyDb4 < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz'
  sha1 'ab36c170dda5b2ceaad3915ced96e41c6b7e493c'

  keg_only "BDB 4.8.30 is provided for software that doesn't compile against newer versions."

  # Fix build under Xcode 4.6
  def patches; DATA; end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--enable-cxx"]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+'docs', doc
    end
  end
end

__END__
diff --git a/dbinc/atomic.h b/dbinc/atomic.h
index 0034dcc..50b8b74 100644
--- a/dbinc/atomic.h
+++ b/dbinc/atomic.h
@@ -144,7 +144,7 @@ typedef LONG volatile *interlocked_val;
 #define	atomic_inc(env, p)	__atomic_inc(p)
 #define	atomic_dec(env, p)	__atomic_dec(p)
 #define	atomic_compare_exchange(env, p, o, n)	\
-	__atomic_compare_exchange((p), (o), (n))
+	__atomic_compare_exchange_db((p), (o), (n))
 static inline int __atomic_inc(db_atomic_t *p)
 {
 	int	temp;
@@ -176,7 +176,7 @@ static inline int __atomic_dec(db_atomic_t *p)
  * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
  * which configure could be changed to use.
  */
-static inline int __atomic_compare_exchange(
+static inline int __atomic_compare_exchange_db(
 	db_atomic_t *p, atomic_value_t oldval, atomic_value_t newval)
 {
 	atomic_value_t was;
