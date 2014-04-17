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
    system "#{bin}/wgdb", "test"
  end
end

__END__
diff --git a/AUTHORS b/AUTHORS
index 9d72685..ee1bfd6 100644
--- a/AUTHORS
+++ b/AUTHORS
@@ -2,7 +2,7 @@ Authors
 =======

 Project lead T.Tammet <tanel.tammet@gmail.com>
-Main programming T.Tammet and P.Järv (priit@cc.ttu.ee)
+Main programming T.Tammet and P.Järv (priit@whitedb.org)

 Additional programming:
 E.Reilent (t-tree) A.Puusepp (java bindings),
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
index 2f66ebd..9a6bfd1 100644
--- a/Db/dblog.c
+++ b/Db/dblog.c
@@ -70,7 +70,6 @@ extern "C" {

 #ifdef _WIN32
 #define snprintf(s, sz, f, ...) _snprintf_s(s, sz+1, sz, f, ## __VA_ARGS__)
-#define inline _inline
 #endif

 #ifndef _WIN32
@@ -274,7 +273,7 @@ abort:
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

@@ -613,7 +612,7 @@ static gint recover_journal(void *db, FILE *f, void *table)
 {
   int c;
   gint length = 0, offset = 0, newoffset;
-  gint col = 0, enc = 0, newenc;
+  gint col = 0, enc = 0, newenc, meta = 0;
   void *rec;

   for(;;) {
@@ -673,6 +672,13 @@ static gint recover_journal(void *db, FILE *f, void *table)
           return show_log_error(db, "Failed to set field data");
         }
         break;
+      case WG_JOURNAL_ENTRY_META:
+        GET_LOG_VARINT(db, f, offset, -1)
+        GET_LOG_VARINT(db, f, meta, -1)
+        newoffset = translate_offset(db, table, offset);
+        rec = offsettoptr(db, newoffset);
+        *((gint *) rec + RECORD_META_POS) = meta;
+        break;
       default:
         return show_log_error(db, "Invalid log entry");
     }
@@ -961,6 +967,7 @@ static gint write_log_buffer(void *db, void *buf, int buflen)
  * WG_JOURNAL_ENTRY_ENC - encode a value (data bytes, extdata if applicable)
  *   followed by a single varint field that contains the encoded value
  * WG_JOURNAL_ENTRY_SET - set a field value (record offset, column, encoded value)
+ * WG_JOURNAL_ENTRY_META - set the metadata of a record
  *
  * lengths, offsets and encoded values are stored as varints
  */
@@ -1116,6 +1123,25 @@ gint wg_log_set_field(void *db, void *rec, gint col, gint data)
 #endif /* USE_DBLOG */
 }

+/** Log setting metadata
+ *
+ *  We assume that dbh->logging.active flag is checked before calling this.
+ */
+gint wg_log_set_meta(void *db, void *rec, gint meta)
+{
+#ifdef USE_DBLOG
+  unsigned char buf[1 + 2*VARINT_SIZE], *optr;
+  buf[0] = WG_JOURNAL_ENTRY_META;
+  optr = &buf[1];
+  optr += enc_varint(optr, (wg_uint) ptrtooffset(db, rec));
+  optr += enc_varint(optr, (wg_uint) meta);
+  return write_log_buffer(db, (void *) buf, optr - buf);
+#else
+  return show_log_error(db, "Logging is disabled");
+#endif /* USE_DBLOG */
+}
+
+
 /* ------------ error handling ---------------- */

 static gint show_log_error(void *db, char *errmsg) {
diff --git a/Db/dblog.h b/Db/dblog.h
index e51212b..9afefb4 100644
--- a/Db/dblog.h
+++ b/Db/dblog.h
@@ -44,8 +44,9 @@
 #define WG_JOURNAL_ENTRY_CRE ((unsigned char) 0x40)
 #define WG_JOURNAL_ENTRY_DEL ((unsigned char) 0x80)
 #define WG_JOURNAL_ENTRY_SET ((unsigned char) 0xc0)
-#define WG_JOURNAL_ENTRY_CMDMASK (0xc0)
-#define WG_JOURNAL_ENTRY_TYPEMASK (0x3f)
+#define WG_JOURNAL_ENTRY_META ((unsigned char) 0x20)
+#define WG_JOURNAL_ENTRY_CMDMASK (0xe0)
+#define WG_JOURNAL_ENTRY_TYPEMASK (0x1f)


 /* ====== data structures ======== */
@@ -71,5 +72,6 @@ gint wg_log_encval(void *db, gint enc);
 gint wg_log_encode(void *db, gint type, void *data, gint length,
   void *extdata, gint extlength);
 gint wg_log_set_field(void *db, void *rec, gint col, gint data);
+gint wg_log_set_meta(void *db, void *rec, gint meta);

 #endif /* DEFINED_DBLOG_H */
diff --git a/Db/dbmem.c b/Db/dbmem.c
index deb2156..301ab4f 100644
--- a/Db/dbmem.c
+++ b/Db/dbmem.c
@@ -80,6 +80,21 @@ static gint show_memory_error_nr(char* errmsg, int nr);

 /* ----------- dbase creation and deletion api funs ------------------ */

+/* Check the header for compatibility.
+ * XXX: this is not required for a fresh database. */
+#define CHECK_SEGMENT(shmx) \
+  if(shmx) { \
+    int err; \
+    if((err = wg_check_header_compat(dbmemsegh(shmx)))) { \
+      if(err < -1) { \
+        show_memory_error("Existing segment header is incompatible"); \
+        wg_print_code_version(); \
+        wg_print_header_version(dbmemsegh(shmx)); \
+      } \
+      return NULL; \
+    } \
+  }
+
 /** returns a pointer to the database, NULL if failure
  *
  * In case database with dbasename exists, the returned pointer
@@ -97,19 +112,7 @@ static gint show_memory_error_nr(char* errmsg, int nr);

 void* wg_attach_database(char* dbasename, gint size){
   void* shm = wg_attach_memsegment(dbasename, size, size, 1, 0);
-  if(shm) {
-    int err;
-    /* Check the header for compatibility.
-     * XXX: this is not required for a fresh database. */
-    if((err = wg_check_header_compat(dbmemsegh(shm)))) {
-      if(err < -1) {
-        show_memory_error("Existing segment header is incompatible");
-        wg_print_code_version();
-        wg_print_header_version(dbmemsegh(shm));
-      }
-      return NULL;
-    }
-  }
+  CHECK_SEGMENT(shm)
   return shm;
 }

@@ -121,19 +124,7 @@ void* wg_attach_database(char* dbasename, gint size){

 void* wg_attach_existing_database(char* dbasename){
   void* shm = wg_attach_memsegment(dbasename, 0, 0, 0, 0);
-  if(shm) {
-    int err;
-    /* Check the header for compatibility.
-     * XXX: this is not required for a fresh database. */
-    if((err = wg_check_header_compat(dbmemsegh(shm)))) {
-      if(err < -1) {
-        show_memory_error("Existing segment header is incompatible");
-        wg_print_code_version();
-        wg_print_header_version(dbmemsegh(shm));
-      }
-      return NULL;
-    }
-  }
+  CHECK_SEGMENT(shm)
   return shm;
 }

@@ -144,19 +135,7 @@ void* wg_attach_existing_database(char* dbasename){

 void* wg_attach_logged_database(char* dbasename, gint size){
   void* shm = wg_attach_memsegment(dbasename, size, size, 1, 1);
-  if(shm) {
-    int err;
-    /* Check the header for compatibility.
-     * XXX: this is not required for a fresh database. */
-    if((err = wg_check_header_compat(dbmemsegh(shm)))) {
-      if(err < -1) {
-        show_memory_error("Existing segment header is incompatible");
-        wg_print_code_version();
-        wg_print_header_version(dbmemsegh(shm));
-      }
-      return NULL;
-    }
-  }
+  CHECK_SEGMENT(shm)
   return shm;
 }

diff --git a/Db/dbschema.c b/Db/dbschema.c
index 2c8fac2..0b69dd9 100644
--- a/Db/dbschema.c
+++ b/Db/dbschema.c
@@ -45,6 +45,7 @@ extern "C" {
 #include "dbcompare.h"
 #include "dbindex.h"
 #include "dbschema.h"
+#include "dblog.h"

 /* ======== Data ========================= */

@@ -95,18 +96,26 @@ void *wg_create_triple(void *db, gint subj, gint prop, gint ob, gint isparam) {
  */
 void *wg_create_array(void *db, gint size, gint isdocument, gint isparam) {
   void *rec = wg_create_raw_record(db, size);
-  gint *meta;
+  gint *metap, meta;
   if(rec) {
-    meta = ((gint *) rec + RECORD_META_POS);
-    *meta |= RECORD_META_ARRAY;
+    metap = ((gint *) rec + RECORD_META_POS);
+    meta = *metap; /* Temp variable used for write-ahead logging */
+    meta |= RECORD_META_ARRAY;
     if(isdocument)
-      *meta |= RECORD_META_DOC;
+      meta |= RECORD_META_DOC;

     if(isparam) {
-      *meta |= (RECORD_META_NOTDATA|RECORD_META_MATCH);
+      meta |= (RECORD_META_NOTDATA|RECORD_META_MATCH);
     } else if(wg_index_add_rec(db, rec) < -1) {
       return NULL; /* index error */
     }
+#ifdef USE_DBLOG
+    if(dbmemsegh(db)->logging.active) {
+      if(wg_log_set_meta(db, rec, meta))
+        return NULL;
+    }
+#endif
+    *metap = meta;
   }
   return rec;
 }
@@ -120,18 +129,26 @@ void *wg_create_array(void *db, gint size, gint isdocument, gint isparam) {
  */
 void *wg_create_object(void *db, gint size, gint isdocument, gint isparam) {
   void *rec = wg_create_raw_record(db, size);
-  gint *meta;
+  gint *metap, meta;
   if(rec) {
-    meta = ((gint *) rec + RECORD_META_POS);
-    *meta |= RECORD_META_OBJECT;
+    metap = ((gint *) rec + RECORD_META_POS);
+    meta = *metap;
+    meta |= RECORD_META_OBJECT;
     if(isdocument)
-      *meta |= RECORD_META_DOC;
+      meta |= RECORD_META_DOC;

     if(isparam) {
-      *meta |= (RECORD_META_NOTDATA|RECORD_META_MATCH);
+      meta |= (RECORD_META_NOTDATA|RECORD_META_MATCH);
     } else if(wg_index_add_rec(db, rec) < -1) {
       return NULL; /* index error */
     }
+#ifdef USE_DBLOG
+    if(dbmemsegh(db)->logging.active) {
+      if(wg_log_set_meta(db, rec, meta))
+        return NULL;
+    }
+#endif
+    *metap = meta;
   }
   return rec;
 }
diff --git a/Db/dbtest.c b/Db/dbtest.c
index 18d8252..4536f82 100644
--- a/Db/dbtest.c
+++ b/Db/dbtest.c
@@ -4443,7 +4443,7 @@ gint wg_check_log(void* db, int printlevel) {

   /* Do various operations in the database:
    * Encode short/long strings, doubles, ints
-   * Create records
+   * Create records (also with different meta bits)
    * Delete records
    * Set fields
    */
@@ -4470,6 +4470,9 @@ gint wg_check_log(void* db, int printlevel) {
   for(i=0; i<10; i++)
     wg_set_field(db, rec1, i, wg_encode_int(db, (~((gint) 0))-i));

+  rec1 = wg_create_object(db, 1, 0, 0);
+  rec1 = wg_create_array(db, 4, 1, 0);
+
 #ifndef _WIN32
   close(ld->fd);
 #else
@@ -4506,6 +4509,8 @@ gint wg_check_log(void* db, int printlevel) {
   rec2 = wg_get_first_record(clonedb);
   while(rec1) {
     int len1, len2;
+    gint meta1, meta2;
+
     if(!rec2) {
       if(printlevel)
         printf("Error: clone database had fewer records\n");
@@ -4522,6 +4527,15 @@ gint wg_check_log(void* db, int printlevel) {
       break;
     }

+    meta1 = *((gint *) rec1 + RECORD_META_POS);
+    meta2 = *((gint *) rec2 + RECORD_META_POS);
+    if(meta1 != meta2) {
+      if(printlevel)
+        printf("Error: records had different metadata\n");
+      err = 1;
+      break;
+    }
+
     for(i=0; i<len1; i++) {
       gint type1, type2;
       int intdata1, intdata2;
