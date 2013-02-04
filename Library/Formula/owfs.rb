require 'formula'

class Owfs < Formula
  homepage 'http://owfs.org/'
  url 'http://sourceforge.net/projects/owfs/files/owfs/2.8p21/owfs-2.8p21.tar.gz'
  version '2.8p21'
  sha1 '253b70aef2637dc60beeb0187254b69abe158e43'

  depends_on 'libusb-compat'

  # Fixes inline functions in clang.
  # Reported upstream:
  # http://sourceforge.net/mailarchive/message.php?msg_id=30219156
  def patches
    DATA if ENV.compiler == :clang
  end

  def install
    # Fix include of getline and strsep to avoid crash
    inreplace 'configure', '-D_POSIX_C_SOURCE=200112L', ''

    # 'tac' command is missing in MacOSX
    inreplace 'src/man/Makefile.am', 'tac', 'tail -r'
    inreplace 'src/man/Makefile.in', 'tac', 'tail -r'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "owserver --version"
  end
end


__END__

diff --git a/module/owlib/src/include/rwlock.h b/module/owlib/src/include/rwlock.h
index 29246ea..57fce7a 100644
--- a/module/owlib/src/include/rwlock.h
+++ b/module/owlib/src/include/rwlock.h
@@ -26,10 +26,10 @@ typedef struct {
 } my_rwlock_t;

 void my_rwlock_init(my_rwlock_t * rwlock);
-inline void my_rwlock_write_lock(my_rwlock_t * rwlock);
-inline void my_rwlock_write_unlock(my_rwlock_t * rwlock);
-inline void my_rwlock_read_lock(my_rwlock_t * rwlock);
-inline void my_rwlock_read_unlock(my_rwlock_t * rwlock);
+void my_rwlock_write_lock(my_rwlock_t * rwlock);
+void my_rwlock_write_unlock(my_rwlock_t * rwlock);
+void my_rwlock_read_lock(my_rwlock_t * rwlock);
+void my_rwlock_read_unlock(my_rwlock_t * rwlock);
 void my_rwlock_destroy(my_rwlock_t * rwlock);

 #else /* not OW_MT */
diff --git a/module/ownet/c/src/include/rwlock.h b/module/ownet/c/src/include/rwlock.h
index 28fc598..c5e6188 100644
--- a/module/ownet/c/src/include/rwlock.h
+++ b/module/ownet/c/src/include/rwlock.h
@@ -26,10 +26,10 @@ typedef struct {
 } my_rwlock_t;

 void my_rwlock_init(my_rwlock_t * rwlock);
-inline void my_rwlock_write_lock(my_rwlock_t * rwlock);
-inline void my_rwlock_write_unlock(my_rwlock_t * rwlock);
-inline void my_rwlock_read_lock(my_rwlock_t * rwlock);
-inline void my_rwlock_read_unlock(my_rwlock_t * rwlock);
+void my_rwlock_write_lock(my_rwlock_t * rwlock);
+void my_rwlock_write_unlock(my_rwlock_t * rwlock);
+void my_rwlock_read_lock(my_rwlock_t * rwlock);
+void my_rwlock_read_unlock(my_rwlock_t * rwlock);
 void my_rwlock_destroy(my_rwlock_t * rwlock);

 #endif             /* OW_MT */
