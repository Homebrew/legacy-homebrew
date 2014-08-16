require "formula"

class Whitedb < Formula
  homepage "http://whitedb.org/"
  url "http://whitedb.org/whitedb-0.7.2.tar.gz"
  sha1 "055b6162e4c0eb225ab95347643fda583c0bbddd"

  depends_on "python" => :optional

  # Patch removing the inline attribute from functions that use it. The author
  # is aware of the issue and the patch was commited three months ago. However,
  # there are no plans yet for an upcoming 0.7.3 release that would include
  # this patch.
  #
  # Link to issue: https://github.com/priitj/whitedb/issues/15
  # Link to patch: https://github.com/priitj/whitedb/compare/91bc516e312b292bd2fd46806c0214c2e49c64d6...ad30631c6c164505a4461929cb09efd6473b2542
  #
  # This patch can safely be removed once 0.7.3 is released.
  patch :DATA

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-python" if build.with? "python"
    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wgdb", "create", "512k"
    system "#{bin}/wgdb", "add", "42"
    system "#{bin}/wgdb", "select", "1"
    system "#{bin}/wgdb", "free"
  end
end

__END__
diff --git a/Db/dblock.c b/Db/dblock.c
index cfdaa30..ec24618 100644
--- a/Db/dblock.c
+++ b/Db/dblock.c
@@ -127,11 +127,6 @@ typedef int (kernel_cmpxchg_t) (int oldval, int newval, int *ptr);
 #endif

 #ifdef _WIN32
-/* XXX: quick hack for MSVC. Should probably find a cleaner solution */
-#define inline __inline
-#endif
-
-#ifdef _WIN32
 #define INIT_SPIN_TIMEOUT(t)
 #else /* timings are in nsec */
 #define INIT_SPIN_TIMEOUT(t) \
@@ -174,21 +169,21 @@ typedef int (kernel_cmpxchg_t) (int oldval, int newval, int *ptr);
 /* ======= Private protos ================ */


-static inline void atomic_increment(volatile gint *ptr, gint incr);
-static inline void atomic_and(volatile gint *ptr, gint val);
-static inline gint fetch_and_add(volatile gint *ptr, gint incr);
-static inline gint fetch_and_store(volatile gint *ptr, gint val);
-// static inline gint compare_and_swap(volatile gint *ptr, gint oldv, gint newv);
+static void atomic_increment(volatile gint *ptr, gint incr);
+static void atomic_and(volatile gint *ptr, gint val);
+static gint fetch_and_add(volatile gint *ptr, gint incr);
+static gint fetch_and_store(volatile gint *ptr, gint val);
+// static gint compare_and_swap(volatile gint *ptr, gint oldv, gint newv);

 #if (LOCK_PROTO==TFQUEUE)
-static inline gint alloc_lock(void * db);
-static inline void free_lock(void * db, gint node);
+static gint alloc_lock(void * db);
+static void free_lock(void * db, gint node);
 /*static gint deref_link(void *db, volatile gint *link);*/
 #ifdef __linux__
-static inline void futex_wait(volatile gint *addr1, int val1);
-static inline int futex_trywait(volatile gint *addr1, int val1,
+static void futex_wait(volatile gint *addr1, int val1);
+static int futex_trywait(volatile gint *addr1, int val1,
   struct timespec *timeout);
-static inline void futex_wake(volatile gint *addr1, int val1);
+static void futex_wake(volatile gint *addr1, int val1);
 #endif
 #endif

@@ -208,7 +203,7 @@ static gint show_lock_error(void *db, char *errmsg);
  *  the same as fetch_and_add().
  */

-static inline void atomic_increment(volatile gint *ptr, gint incr) {
+static void atomic_increment(volatile gint *ptr, gint incr) {
 #if defined(DUMMY_ATOMIC_OPS)
   *ptr += incr;
 #elif defined(__GNUC__)
@@ -244,7 +239,7 @@ static inline void atomic_increment(volatile gint *ptr, gint incr) {
 /** Atomic AND operation.
  */

-static inline void atomic_and(volatile gint *ptr, gint val) {
+static void atomic_and(volatile gint *ptr, gint val) {
 #if defined(DUMMY_ATOMIC_OPS)
   *ptr &= val;
 #elif defined(__GNUC__)
@@ -280,7 +275,7 @@ static inline void atomic_and(volatile gint *ptr, gint val) {
 /** Atomic OR operation.
  */

-static inline void atomic_or(volatile gint *ptr, gint val) {
+static void atomic_or(volatile gint *ptr, gint val) {
 #if defined(DUMMY_ATOMIC_OPS)
   *ptr |= val;
 #elif defined(__GNUC__)
@@ -316,7 +311,7 @@ static inline void atomic_or(volatile gint *ptr, gint val) {
 /** Fetch and (dec|inc)rement. Returns value before modification.
  */

-static inline gint fetch_and_add(volatile gint *ptr, gint incr) {
+static gint fetch_and_add(volatile gint *ptr, gint incr) {
 #if defined(DUMMY_ATOMIC_OPS)
   gint tmp = *ptr;
   *ptr += incr;
@@ -356,7 +351,7 @@ static inline gint fetch_and_add(volatile gint *ptr, gint incr) {
 /** Atomic fetch and store. Swaps two values.
  */

-static inline gint fetch_and_store(volatile gint *ptr, gint val) {
+static gint fetch_and_store(volatile gint *ptr, gint val) {
   /* Despite the name, the GCC builtin should just
    * issue XCHG operation. There is no testing of
    * anything, just lock the bus and swap the values,
@@ -404,7 +399,7 @@ static inline gint fetch_and_store(volatile gint *ptr, gint val) {
  *  new and return 1. Otherwise the function returns 0.
  */

-inline gint wg_compare_and_swap(volatile gint *ptr, gint oldv, gint newv) {
+gint wg_compare_and_swap(volatile gint *ptr, gint oldv, gint newv) {
 #if defined(DUMMY_ATOMIC_OPS)
   if(*ptr == oldv) {
     *ptr = newv;
@@ -1288,7 +1283,7 @@ gint wg_init_locks(void * db) {
  */

 #if 0
-static inline gint alloc_lock(void * db) {
+static gint alloc_lock(void * db) {
   db_memsegment_header* dbh = dbmemsegh(db);
   lock_queue_node *tmp;

@@ -1315,7 +1310,7 @@ static inline gint alloc_lock(void * db) {
  *   Used internally only.
  */

-static inline void free_lock(void * db, gint node) {
+static void free_lock(void * db, gint node) {
   db_memsegment_header* dbh = dbmemsegh(db);
   lock_queue_node *tmp;
   volatile gint t;
@@ -1342,7 +1337,7 @@ static inline void free_lock(void * db, gint node) {
  *   Used internally only.
  */

-static inline gint deref_link(void *db, volatile gint *link) {
+static gint deref_link(void *db, volatile gint *link) {
   lock_queue_node *tmp;
   volatile gint t;

@@ -1361,7 +1356,7 @@ static inline gint deref_link(void *db, volatile gint *link) {
 #else
 /* Simple lock memory allocation (non lock-free) */

-static inline gint alloc_lock(void * db) {
+static gint alloc_lock(void * db) {
   db_memsegment_header* dbh = dbmemsegh(db);
   gint t = dbh->locks.freelist;
   lock_queue_node *tmp;
@@ -1374,7 +1369,7 @@ static inline gint alloc_lock(void * db) {
   return t;
 }

-static inline void free_lock(void * db, gint node) {
+static void free_lock(void * db, gint node) {
   db_memsegment_header* dbh = dbmemsegh(db);
   lock_queue_node *tmp = (lock_queue_node *) offsettoptr(db, node);
   tmp->next_cell = dbh->locks.freelist;
@@ -1386,12 +1381,12 @@ static inline void free_lock(void * db, gint node) {
 #ifdef __linux__
 /* Futex operations */

-static inline void futex_wait(volatile gint *addr1, int val1)
+static void futex_wait(volatile gint *addr1, int val1)
 {
   syscall(SYS_futex, (void *) addr1, FUTEX_WAIT, val1, NULL);
 }

-static inline int futex_trywait(volatile gint *addr1, int val1,
+static int futex_trywait(volatile gint *addr1, int val1,
   struct timespec *timeout)
 {
   if(syscall(SYS_futex, (void *) addr1, FUTEX_WAIT, val1, timeout) == -1)
@@ -1400,7 +1395,7 @@ static inline int futex_trywait(volatile gint *addr1, int val1,
     return 0;
 }

-static inline void futex_wake(volatile gint *addr1, int val1)
+static void futex_wake(volatile gint *addr1, int val1)
 {
   syscall(SYS_futex, (void *) addr1, FUTEX_WAKE, val1);
 }
diff --git a/Db/dblock.h b/Db/dblock.h
index 0f3feff..e1c985f 100644
--- a/Db/dblock.h
+++ b/Db/dblock.h
@@ -79,11 +79,7 @@ gint wg_end_read(void * dbase, gint lock);  /* end read transaction */

 /* WhiteDB internal functions */

-#ifndef _WIN32
-inline gint wg_compare_and_swap(volatile gint *ptr, gint oldv, gint newv);
-#else
-__inline gint wg_compare_and_swap(volatile gint *ptr, gint oldv, gint newv);
-#endif
+gint wg_compare_and_swap(volatile gint *ptr, gint oldv, gint newv);
 gint wg_init_locks(void * db); /* (re-) initialize locking subsystem */

 #if (LOCK_PROTO==RPSPIN)
diff --git a/Db/dblog.c b/Db/dblog.c
index de88bf9..9a6bfd1 100644
--- a/Db/dblog.c
+++ b/Db/dblog.c
@@ -70,7 +70,6 @@ extern "C" {

 #ifdef _WIN32
 #define snprintf(s, sz, f, ...) _snprintf_s(s, sz+1, sz, f, ## __VA_ARGS__)
-#define inline _inline
 #endif

 #ifndef _WIN32
@@ -274,7 +273,7 @@ static int open_journal(void *db, int create) {
  *  be at least 9 bytes.
  *  based on http://stackoverflow.com/a/2982965
  */
-static inline size_t enc_varint(unsigned char *buf, wg_uint val) {
+static size_t enc_varint(unsigned char *buf, wg_uint val) {
   buf[0] = (unsigned char)(val | 0x80);
   if(val >= (1 << 7)) {
     buf[1] = (unsigned char)((val >>  7) | 0x80);
@@ -339,7 +338,7 @@ static inline size_t enc_varint(unsigned char *buf, wg_uint val) {
  *  assumes we're using a read buffer - this is acceptable and
  *  probably preferable when doing the journal replay.
  */
-static inline size_t dec_varint(unsigned char *buf, wg_uint *val) {
+static size_t dec_varint(unsigned char *buf, wg_uint *val) {
   wg_uint tmp = buf[0] & 0x7f;
   if(buf[0] & 0x80) {
     tmp |= ((buf[1] & 0x7f) << 7);
@@ -404,7 +403,7 @@ static inline size_t dec_varint(unsigned char *buf, wg_uint *val) {
  *  returns 0 on success
  *  returns -1 on error
  */
-static inline int fget_varint(void *db, FILE *f, wg_uint *val) {
+static int fget_varint(void *db, FILE *f, wg_uint *val) {
   register int c;
   wg_uint tmp;

