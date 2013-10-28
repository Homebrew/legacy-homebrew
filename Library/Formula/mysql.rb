require 'formula'

class Mysql < Formula
  homepage 'http://dev.mysql.com/doc/refman/5.6/en/'
  url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz/from/http://cdn.mysql.com/'
  version '5.6.13'
  sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'

  bottle do
    revision 2
    sha1 '58e852b4914b2102144879c51e501c94429be32c' => :mavericks
    sha1 'adac8eaa66a75b909ed148e54b273ae65c3d725a' => :mountain_lion
    sha1 'c9f65ec043617775e08f277fedf099ed70fdcef3' => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'pidof' unless MacOS.version >= :mountain_lion

  option :universal
  option 'with-tests', 'Build with unit tests'
  option 'with-embedded', 'Build the embedded server'
  option 'with-libedit', 'Compile with editline wrapper instead of readline'
  option 'with-archive-storage-engine', 'Compile with the ARCHIVE storage engine enabled'
  option 'with-blackhole-storage-engine', 'Compile with the BLACKHOLE storage engine enabled'
  option 'enable-local-infile', 'Build with local infile loading support'
  option 'enable-memcached', 'Enable innodb-memcached support'
  option 'enable-debug', 'Build with debug support'

  conflicts_with 'mysql-cluster', 'mariadb', 'percona-server',
    :because => "mysql, mariadb, and percona install the same binaries."

  env :std if build.universal?

  fails_with :llvm do
    build 2326
    cause "https://github.com/mxcl/homebrew/issues/issue/144"
  end

  def patches
    DATA
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/mxcl/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{var}/mysql",
            "-DINSTALL_MANDIR=#{man}",
            "-DINSTALL_DOCDIR=#{doc}",
            "-DINSTALL_INFODIR=#{info}",
            # CMake prepends prefix, so use share.basename
            "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/#{name}",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.include? 'with-tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.include? 'with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless build.include? 'with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.include? 'with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.include? 'with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='#{Hardware::CPU.universal_archs.as_cmake_arch_flags}'" if build.universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'

    # Build with memcached support
    args << "-DWITH_INNODB_MEMCACHED=1" if build.include? 'enable-memcached'

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.include? 'enable-debug'

    system "cmake", *args
    system "make"
    # Reported upstream:
    # http://bugs.mysql.com/bug.php?id=69645
    inreplace "scripts/mysql_config", / +-Wno[\w-]+/, ""
    system "make install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Link the setup script into bin
    ln_s prefix+'scripts/mysql_install_db', bin+'mysql_install_db'
    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, 'pgrep') if MacOS.version >= :mountain_lion
    end
    ln_s "#{prefix}/support-files/mysql.server", bin

    # Move mysqlaccess to libexec
    mv "#{bin}/mysqlaccess", libexec
    mv "#{bin}/mysqlaccess.conf", libexec

    # Make sure the var/mysql directory exists
    (var+"mysql").mkpath
  end

  def post_install
    unless File.exist? "#{var}/mysql/mysql/user.frm"
      ENV['TMPDIR'] = nil
      system "#{bin}/mysql_install_db", '--verbose', "--user=#{ENV['USER']}",
        "--basedir=#{prefix}", "--datadir=#{var}/mysql", "--tmpdir=/tmp"
    end
  end

  def caveats; <<-EOS.undent
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot
    EOS
  end

  plist_options :manual => "mysql.server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/bin/mysqld_safe</string>
        <string>--bind-address=127.0.0.1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    (prefix+'mysql-test').cd do
      system './mysql-test-run.pl', 'status'
    end
  end
end

__END__
diff -ur a/client/mysql.cc b/client/mysql.cc
--- a/client/mysql.cc	2013-07-10 17:17:29.000000000 +0100
+++ b/client/mysql.cc	2013-10-08 15:24:33.000000000 +0100
@@ -234,8 +234,8 @@
   The same is true for stderr.
 */
 static uint win_is_console_cache= 
-  (test(my_win_is_console(stdout)) * (1 << _fileno(stdout))) |
-  (test(my_win_is_console(stderr)) * (1 << _fileno(stderr)));
+  (mysql_test(my_win_is_console(stdout)) * (1 << _fileno(stdout))) |
+  (mysql_test(my_win_is_console(stderr)) * (1 << _fileno(stderr)));
 
 static inline my_bool
 my_win_is_console_cached(FILE *file)
diff -ur a/include/my_global.h b/include/my_global.h
--- a/include/my_global.h	2013-07-10 17:17:27.000000000 +0100
+++ b/include/my_global.h	2013-10-08 15:04:59.000000000 +0100
@@ -461,7 +461,7 @@
 #endif
 
 #define swap_variables(t, a, b) { t dummy; dummy= a; a= b; b= dummy; }
-#define test(a)		((a) ? 1 : 0)
+#define mysql_test(a)		((a) ? 1 : 0)
 #define set_if_bigger(a,b)  do { if ((a) < (b)) (a)=(b); } while(0)
 #define set_if_smaller(a,b) do { if ((a) > (b)) (a)=(b); } while(0)
 #define test_all_bits(a,b) (((a) & (b)) == (b))
diff -ur a/include/myisam.h b/include/myisam.h
--- a/include/myisam.h	2013-07-10 17:17:27.000000000 +0100
+++ b/include/myisam.h	2013-10-08 15:11:50.000000000 +0100
@@ -80,8 +80,8 @@
 
 #define mi_is_key_active(_keymap_,_keyno_) \
                             (((_keyno_) < MI_KEYMAP_BITS) ? \
-                             test((_keymap_) & (ULL(1) << (_keyno_))) : \
-                             test((_keymap_) & MI_KEYMAP_HIGH_MASK))
+                             mysql_test((_keymap_) & (ULL(1) << (_keyno_))) : \
+                             mysql_test((_keymap_) & MI_KEYMAP_HIGH_MASK))
 #define mi_set_key_active(_keymap_,_keyno_) \
                             (_keymap_)|= (((_keyno_) < MI_KEYMAP_BITS) ? \
                                           (ULL(1) << (_keyno_)) : \
@@ -94,7 +94,7 @@
 #else
 
 #define mi_is_key_active(_keymap_,_keyno_) \
-                            test((_keymap_) & (ULL(1) << (_keyno_)))
+                            mysql_test((_keymap_) & (ULL(1) << (_keyno_)))
 #define mi_set_key_active(_keymap_,_keyno_) \
                             (_keymap_)|= (ULL(1) << (_keyno_))
 #define mi_clear_key_active(_keymap_,_keyno_) \
@@ -103,7 +103,7 @@
 #endif
 
 #define mi_is_any_key_active(_keymap_) \
-                            test((_keymap_))
+                            mysql_test((_keymap_))
 #define mi_is_all_keys_active(_keymap_,_keys_) \
                             ((_keymap_) == mi_get_mask_all_keys_active(_keys_))
 #define mi_set_all_keys_active(_keymap_,_keys_) \
diff -ur a/libmysql/libmysql.c b/libmysql/libmysql.c
--- a/libmysql/libmysql.c	2013-07-10 17:17:29.000000000 +0100
+++ b/libmysql/libmysql.c	2013-10-08 15:11:50.000000000 +0100
@@ -2071,7 +2071,7 @@
   buff[4]= (char) stmt->flags;
   int4store(buff+5, 1);                         /* iteration count */
 
-  res= test(cli_advanced_command(mysql, COM_STMT_EXECUTE, buff, sizeof(buff),
+  res= mysql_test(cli_advanced_command(mysql, COM_STMT_EXECUTE, buff, sizeof(buff),
                                  (uchar*) packet, length, 1, stmt) ||
             (*mysql->methods->read_query_result)(mysql));
   stmt->affected_rows= mysql->affected_rows;
@@ -2559,7 +2559,7 @@
     reinit_result_set_metadata(stmt);
     prepare_to_fetch_result(stmt);
   }
-  DBUG_RETURN(test(stmt->last_errno));
+  DBUG_RETURN(mysql_test(stmt->last_errno));
 }
 
 
@@ -3179,7 +3179,7 @@
     int err;
     double data= my_strntod(&my_charset_latin1, value, length, &endptr, &err);
     float fdata= (float) data;
-    *param->error= (fdata != data) | test(err);
+    *param->error= (fdata != data) | mysql_test(err);
     floatstore(buffer, fdata);
     break;
   }
@@ -3187,7 +3187,7 @@
   {
     int err;
     double data= my_strntod(&my_charset_latin1, value, length, &endptr, &err);
-    *param->error= test(err);
+    *param->error= mysql_test(err);
     doublestore(buffer, data);
     break;
   }
@@ -3196,7 +3196,7 @@
     MYSQL_TIME_STATUS status;
     MYSQL_TIME *tm= (MYSQL_TIME *)buffer;
     str_to_time(value, length, tm, &status);
-    *param->error= test(status.warnings);
+    *param->error= mysql_test(status.warnings);
     break;
   }
   case MYSQL_TYPE_DATE:
@@ -3206,7 +3206,7 @@
     MYSQL_TIME_STATUS status;
     MYSQL_TIME *tm= (MYSQL_TIME *)buffer;
     (void) str_to_datetime(value, length, tm, TIME_FUZZY_DATE, &status);
-    *param->error= test(status.warnings) &&
+    *param->error= mysql_test(status.warnings) &&
                    (param->buffer_type == MYSQL_TYPE_DATE &&
                     tm->time_type != MYSQL_TIMESTAMP_DATE);
     break;
@@ -3331,7 +3331,7 @@
     int error;
     value= number_to_datetime(value, (MYSQL_TIME *) buffer, TIME_FUZZY_DATE,
                               &error);
-    *param->error= test(error);
+    *param->error= mysql_test(error);
     break;
   }
   default:
@@ -3679,7 +3679,7 @@
 static void fetch_result_tinyint(MYSQL_BIND *param, MYSQL_FIELD *field,
                                  uchar **row)
 {
-  my_bool field_is_unsigned= test(field->flags & UNSIGNED_FLAG);
+  my_bool field_is_unsigned= mysql_test(field->flags & UNSIGNED_FLAG);
   uchar data= **row;
   *(uchar *)param->buffer= data;
   *param->error= param->is_unsigned != field_is_unsigned && data > INT_MAX8;
@@ -3689,7 +3689,7 @@
 static void fetch_result_short(MYSQL_BIND *param, MYSQL_FIELD *field,
                                uchar **row)
 {
-  my_bool field_is_unsigned= test(field->flags & UNSIGNED_FLAG);
+  my_bool field_is_unsigned= mysql_test(field->flags & UNSIGNED_FLAG);
   ushort data= (ushort) sint2korr(*row);
   shortstore(param->buffer, data);
   *param->error= param->is_unsigned != field_is_unsigned && data > INT_MAX16;
@@ -3700,7 +3700,7 @@
                                MYSQL_FIELD *field __attribute__((unused)),
                                uchar **row)
 {
-  my_bool field_is_unsigned= test(field->flags & UNSIGNED_FLAG);
+  my_bool field_is_unsigned= mysql_test(field->flags & UNSIGNED_FLAG);
   uint32 data= (uint32) sint4korr(*row);
   longstore(param->buffer, data);
   *param->error= param->is_unsigned != field_is_unsigned && data > INT_MAX32;
@@ -3711,7 +3711,7 @@
                                MYSQL_FIELD *field __attribute__((unused)),
                                uchar **row)
 {
-  my_bool field_is_unsigned= test(field->flags & UNSIGNED_FLAG);
+  my_bool field_is_unsigned= mysql_test(field->flags & UNSIGNED_FLAG);
   ulonglong data= (ulonglong) sint8korr(*row);
   *param->error= param->is_unsigned != field_is_unsigned && data > LONGLONG_MAX;
   longlongstore(param->buffer, data);
@@ -4705,7 +4705,7 @@
   my_free(stmt->extension);
   my_free(stmt);
 
-  DBUG_RETURN(test(rc));
+  DBUG_RETURN(mysql_test(rc));
 }
 
 /*
diff -ur a/libmysqld/lib_sql.cc b/libmysqld/lib_sql.cc
--- a/libmysqld/lib_sql.cc	2013-07-10 17:17:29.000000000 +0100
+++ b/libmysqld/lib_sql.cc	2013-10-08 15:24:34.000000000 +0100
@@ -337,7 +337,7 @@
   thd->client_param_count= stmt->param_count;
   thd->client_params= stmt->params;
 
-  res= test(emb_advanced_command(stmt->mysql, COM_STMT_EXECUTE, 0, 0,
+  res= mysql_test(emb_advanced_command(stmt->mysql, COM_STMT_EXECUTE, 0, 0,
                                  header, sizeof(header), 1, stmt) ||
             emb_read_query_result(stmt->mysql));
   stmt->affected_rows= stmt->mysql->affected_rows;
diff -ur a/mysys/mf_iocache.c b/mysys/mf_iocache.c
--- a/mysys/mf_iocache.c	2013-07-10 17:17:27.000000000 +0100
+++ b/mysys/mf_iocache.c	2013-10-08 15:11:51.000000000 +0100
@@ -180,7 +180,7 @@
       DBUG_ASSERT(seek_offset == 0);
     }
     else
-      info->seek_not_done= test(seek_offset != pos);
+      info->seek_not_done= mysql_test(seek_offset != pos);
   }
 
   info->disk_writes= 0;
diff -ur a/mysys/my_copy.c b/mysys/my_copy.c
--- a/mysys/my_copy.c	2013-07-10 17:17:27.000000000 +0100
+++ b/mysys/my_copy.c	2013-10-08 15:11:51.000000000 +0100
@@ -63,7 +63,7 @@
   from_file=to_file= -1;
   DBUG_ASSERT(!(MyFlags & (MY_FNABP | MY_NABP))); /* for my_read/my_write */
   if (MyFlags & MY_HOLD_ORIGINAL_MODES)		/* Copy stat if possible */
-    new_file_stat= test(my_stat((char*) to, &new_stat_buff, MYF(0)));
+    new_file_stat= mysql_test(my_stat((char*) to, &new_stat_buff, MYF(0)));
 
   if ((from_file=my_open(from,O_RDONLY | O_SHARE,MyFlags)) >= 0)
   {
diff -ur a/mysys/my_getwd.c b/mysys/my_getwd.c
--- a/mysys/my_getwd.c	2013-07-10 17:17:27.000000000 +0100
+++ b/mysys/my_getwd.c	2013-10-08 15:11:51.000000000 +0100
@@ -162,12 +162,12 @@
 
 my_bool has_path(const char *name)
 {
-  return test(strchr(name, FN_LIBCHAR)) 
+  return mysql_test(strchr(name, FN_LIBCHAR)) 
 #if FN_LIBCHAR != '/'
-    || test(strchr(name,'/'))
+    || mysql_test(strchr(name,'/'))
 #endif
 #ifdef FN_DEVCHAR
-    || test(strchr(name, FN_DEVCHAR))
+    || mysql_test(strchr(name, FN_DEVCHAR))
 #endif
     ;
 }
diff -ur a/sql/event_db_repository.cc b/sql/event_db_repository.cc
--- a/sql/event_db_repository.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/event_db_repository.cc	2013-10-08 15:24:34.000000000 +0100
@@ -469,7 +469,7 @@
 end:
   event_table->file->ha_index_end();
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
@@ -743,7 +743,7 @@
   thd->mdl_context.rollback_to_savepoint(mdl_savepoint);
 
   thd->variables.sql_mode= saved_mode;
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
@@ -858,7 +858,7 @@
   thd->mdl_context.rollback_to_savepoint(mdl_savepoint);
 
   thd->variables.sql_mode= saved_mode;
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
@@ -918,7 +918,7 @@
   close_thread_tables(thd);
   thd->mdl_context.rollback_to_savepoint(mdl_savepoint);
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
@@ -1153,7 +1153,7 @@
   if (save_binlog_row_based)
     thd->set_current_stmt_binlog_format_row();
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
@@ -1230,7 +1230,7 @@
     close_mysql_tables(thd);
   }
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 /**
diff -ur a/sql/field.cc b/sql/field.cc
--- a/sql/field.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/field.cc	2013-10-08 15:24:35.000000000 +0100
@@ -1855,7 +1855,7 @@
 
 bool Field::optimize_range(uint idx, uint part)
 {
-  return test(table->file->index_flags(idx, part, 1) & HA_READ_RANGE);
+  return mysql_test(table->file->index_flags(idx, part, 1) & HA_READ_RANGE);
 }
 
 
@@ -9571,7 +9571,7 @@
     {
       pack_length= length / 8;
       /* We need one extra byte to store the bits we save among the null bits */
-      key_length= pack_length + test(length & 7);
+      key_length= pack_length + mysql_test(length & 7);
     }
     break;
   case MYSQL_TYPE_NEWDECIMAL:
diff -ur a/sql/field.h b/sql/field.h
--- a/sql/field.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/field.h	2013-10-08 15:11:51.000000000 +0100
@@ -891,14 +891,14 @@
 
     */
     return real_maybe_null() ?
-      test(null_ptr[row_offset] & null_bit) : table->null_row;
+      mysql_test(null_ptr[row_offset] & null_bit) : table->null_row;
   }
 
   bool is_real_null(my_ptrdiff_t row_offset= 0) const
-  { return real_maybe_null() ? test(null_ptr[row_offset] & null_bit) : false; }
+  { return real_maybe_null() ? mysql_test(null_ptr[row_offset] & null_bit) : false; }
 
   bool is_null_in_record(const uchar *record) const
-  { return real_maybe_null() ? test(record[null_offset()] & null_bit) : false; }
+  { return real_maybe_null() ? mysql_test(record[null_offset()] & null_bit) : false; }
 
   void set_null(my_ptrdiff_t row_offset= 0)
   {
@@ -3670,9 +3670,9 @@
   {
     DBUG_ASSERT(ptr == a || ptr == b);
     if (ptr == a)
-      return Field_bit::key_cmp(b, bytes_in_rec+test(bit_len));
+      return Field_bit::key_cmp(b, bytes_in_rec+mysql_test(bit_len));
     else
-      return Field_bit::key_cmp(a, bytes_in_rec+test(bit_len)) * -1;
+      return Field_bit::key_cmp(a, bytes_in_rec+mysql_test(bit_len)) * -1;
   }
   int cmp_binary_offset(uint row_offset)
   { return cmp_offset(row_offset); }
diff -ur a/sql/field_conv.cc b/sql/field_conv.cc
--- a/sql/field_conv.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/field_conv.cc	2013-10-08 15:24:36.000000000 +0100
@@ -331,7 +331,7 @@
 {
   longlong value= copy->from_field->val_int();
   copy->to_field->store(value,
-                        test(copy->from_field->flags & UNSIGNED_FLAG));
+                        mysql_test(copy->from_field->flags & UNSIGNED_FLAG));
 }
 
 static void do_field_real(Copy_field *copy)
@@ -901,5 +901,5 @@
     return to->store_decimal(from->val_decimal(&buff));
   }
   else
-    return to->store(from->val_int(), test(from->flags & UNSIGNED_FLAG));
+    return to->store(from->val_int(), mysql_test(from->flags & UNSIGNED_FLAG));
 }
diff -ur a/sql/ha_ndbcluster.cc b/sql/ha_ndbcluster.cc
--- a/sql/ha_ndbcluster.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/ha_ndbcluster.cc	2013-10-08 15:24:36.000000000 +0100
@@ -2807,7 +2807,7 @@
     if (check_index_fields_not_null(key_info))
       m_index[i].null_in_unique_index= TRUE;
 
-    if (error == 0 && test(index_flags(i, 0, 0) & HA_READ_RANGE))
+    if (error == 0 && mysql_test(index_flags(i, 0, 0) & HA_READ_RANGE))
       btree_keys.set_bit(i);
   }
 
diff -ur a/sql/ha_partition.cc b/sql/ha_partition.cc
--- a/sql/ha_partition.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/ha_partition.cc	2013-10-08 15:24:37.000000000 +0100
@@ -3221,7 +3221,7 @@
   m_mode= mode;
   m_open_test_lock= test_if_locked;
   m_part_field_array= m_part_info->full_part_field_array;
-  if (get_from_handler_file(name, &table->mem_root, test(m_is_clone_of)))
+  if (get_from_handler_file(name, &table->mem_root, mysql_test(m_is_clone_of)))
     DBUG_RETURN(error);
   name_buffer_ptr= m_name_buffer_ptr;
   if (populate_partition_name_hash())
@@ -5483,7 +5483,7 @@
     m_start_key.key= NULL;
 
   m_index_scan_type= partition_read_range;
-  error= common_index_read(m_rec0, test(start_key));
+  error= common_index_read(m_rec0, mysql_test(start_key));
   DBUG_RETURN(error);
 }
 
@@ -7479,7 +7479,7 @@
   ulong nr1= 1;
   ulong nr2= 4;
   bool use_51_hash;
-  use_51_hash= test((*field_array)->table->part_info->key_algorithm ==
+  use_51_hash= mysql_test((*field_array)->table->part_info->key_algorithm ==
                     partition_info::KEY_ALGORITHM_51);
 
   do
diff -ur a/sql/handler.cc b/sql/handler.cc
--- a/sql/handler.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/handler.cc	2013-10-08 15:24:38.000000000 +0100
@@ -5737,7 +5737,7 @@
   DBUG_ENTER("handler::multi_range_read_init");
   mrr_iter= seq_funcs->init(seq_init_param, n_ranges, mode);
   mrr_funcs= *seq_funcs;
-  mrr_is_output_sorted= test(mode & HA_MRR_SORTED);
+  mrr_is_output_sorted= mysql_test(mode & HA_MRR_SORTED);
   mrr_have_range= FALSE;
   DBUG_RETURN(0);
 }
@@ -5793,7 +5793,7 @@
                                  &mrr_cur_range.start_key : 0,
                                mrr_cur_range.end_key.keypart_map ?
                                  &mrr_cur_range.end_key : 0,
-                               test(mrr_cur_range.range_flag & EQ_RANGE),
+                               mysql_test(mrr_cur_range.range_flag & EQ_RANGE),
                                mrr_is_output_sorted);
       if (result != HA_ERR_END_OF_FILE)
         break;
@@ -5890,7 +5890,7 @@
 
   rowids_buf= buf->buffer;
 
-  is_mrr_assoc= !test(mode & HA_MRR_NO_ASSOCIATION);
+  is_mrr_assoc= !mysql_test(mode & HA_MRR_NO_ASSOCIATION);
 
   if (is_mrr_assoc)
     status_var_increment(table->in_use->status_var.ha_multi_range_read_init_count);
@@ -6128,7 +6128,7 @@
 
   if (res && res != HA_ERR_END_OF_FILE)
     DBUG_RETURN(res); 
-  dsmrr_eof= test(res == HA_ERR_END_OF_FILE);
+  dsmrr_eof= mysql_test(res == HA_ERR_END_OF_FILE);
 
   /* Sort the buffer contents by rowid */
   uint elem_size= h->ref_length + (int)is_mrr_assoc * sizeof(void*);
@@ -6181,7 +6181,7 @@
     if (is_mrr_assoc)
       memcpy(&cur_range_info, rowids_buf_cur + h->ref_length, sizeof(uchar*));
 
-    rowids_buf_cur += h->ref_length + sizeof(void*) * test(is_mrr_assoc);
+    rowids_buf_cur += h->ref_length + sizeof(void*) * mysql_test(is_mrr_assoc);
     if (h2->mrr_funcs.skip_record &&
 	h2->mrr_funcs.skip_record(h2->mrr_iter, (char *) cur_range_info, rowid))
       continue;
@@ -6403,7 +6403,7 @@
   double index_read_cost;
 
   const uint elem_size= h->ref_length + 
-                        sizeof(void*) * (!test(flags & HA_MRR_NO_ASSOCIATION));
+                        sizeof(void*) * (!mysql_test(flags & HA_MRR_NO_ASSOCIATION));
   const ha_rows max_buff_entries= *buffer_size / elem_size;
 
   if (!max_buff_entries)
diff -ur a/sql/handler.h b/sql/handler.h
--- a/sql/handler.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/handler.h	2013-10-08 15:11:52.000000000 +0100
@@ -3347,7 +3347,7 @@
 
 static inline bool ha_check_storage_engine_flag(const handlerton *db_type, uint32 flag)
 {
-  return db_type == NULL ? FALSE : test(db_type->flags & flag);
+  return db_type == NULL ? FALSE : mysql_test(db_type->flags & flag);
 }
 
 static inline bool ha_storage_engine_is_enabled(const handlerton *db_type)
diff -ur a/sql/item.cc b/sql/item.cc
--- a/sql/item.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item.cc	2013-10-08 15:24:38.000000000 +0100
@@ -2545,7 +2545,7 @@
   field_name= field_par->field_name;
   db_name= field_par->table->s->db.str;
   alias_name_used= field_par->table->alias_name_used;
-  unsigned_flag=test(field_par->flags & UNSIGNED_FLAG);
+  unsigned_flag=mysql_test(field_par->flags & UNSIGNED_FLAG);
   collation.set(field_par->charset(), field_par->derivation(),
                 field_par->repertoire());
   fix_char_length(field_par->char_length());
diff -ur a/sql/item.h b/sql/item.h
--- a/sql/item.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item.h	2013-10-08 15:11:53.000000000 +0100
@@ -1660,7 +1660,7 @@
   {
     if (is_expensive_cache < 0)
       is_expensive_cache= walk(&Item::is_expensive_processor, 0, (uchar*)0);
-    return test(is_expensive_cache);
+    return mysql_test(is_expensive_cache);
   }
   virtual bool can_be_evaluated_now() const;
   uint32 max_char_length() const
@@ -2597,7 +2597,7 @@
   virtual void print(String *str, enum_query_type query_type);
   Item_num *neg() { value= -value; return this; }
   uint decimal_precision() const
-  { return (uint)(max_length - test(value < 0)); }
+  { return (uint)(max_length - mysql_test(value < 0)); }
   bool eq(const Item *, bool binary_cmp) const;
   bool check_partition_func_processor(uchar *bool_arg) { return FALSE;}
 };
@@ -4197,7 +4197,7 @@
   virtual void store(Item *item);
   virtual bool cache_value()= 0;
   bool basic_const_item() const
-  { return test(example && example->basic_const_item());}
+  { return mysql_test(example && example->basic_const_item());}
   bool walk (Item_processor processor, bool walk_subquery, uchar *argument);
   virtual void clear() { null_value= TRUE; value_cached= FALSE; }
   bool is_null() { return value_cached ? null_value : example->is_null(); }
diff -ur a/sql/item_cmpfunc.cc b/sql/item_cmpfunc.cc
--- a/sql/item_cmpfunc.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_cmpfunc.cc	2013-10-08 15:24:39.000000000 +0100
@@ -497,7 +497,7 @@
                                      *item) :
 #endif
           new Item_int_with_ref(field->val_int(), *item,
-                                test(field->flags & UNSIGNED_FLAG));
+                                mysql_test(field->flags & UNSIGNED_FLAG));
         if (tmp)
           thd->change_item_tree(item, tmp);
         result= 1;                              // Item was replaced
@@ -1425,8 +1425,8 @@
   res1= (*a)->val_str(&value1);
   res2= (*b)->val_str(&value2);
   if (!res1 || !res2)
-    return test(res1 == res2);
-  return test(sortcmp(res1, res2, cmp_collation.collation) == 0);
+    return mysql_test(res1 == res2);
+  return mysql_test(sortcmp(res1, res2, cmp_collation.collation) == 0);
 }
 
 
@@ -1436,8 +1436,8 @@
   res1= (*a)->val_str(&value1);
   res2= (*b)->val_str(&value2);
   if (!res1 || !res2)
-    return test(res1 == res2);
-  return test(stringcmp(res1, res2) == 0);
+    return mysql_test(res1 == res2);
+  return mysql_test(stringcmp(res1, res2) == 0);
 }
 
 
@@ -1492,8 +1492,8 @@
   double val1= (*a)->val_real();
   double val2= (*b)->val_real();
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return test(val1 == val2);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return mysql_test(val1 == val2);
 }
 
 int Arg_comparator::compare_e_decimal()
@@ -1502,8 +1502,8 @@
   my_decimal *val1= (*a)->val_decimal(&decimal1);
   my_decimal *val2= (*b)->val_decimal(&decimal2);
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return test(my_decimal_cmp(val1, val2) == 0);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return mysql_test(my_decimal_cmp(val1, val2) == 0);
 }
 
 
@@ -1541,8 +1541,8 @@
   double val1= (*a)->val_real();
   double val2= (*b)->val_real();
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return test(val1 == val2 || fabs(val1 - val2) < precision);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return mysql_test(val1 == val2 || fabs(val1 - val2) < precision);
 }
 
 
@@ -1616,8 +1616,8 @@
   longlong val1= (*a)->val_time_temporal();
   longlong val2= (*b)->val_time_temporal();
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return test(val1 == val2);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return mysql_test(val1 == val2);
 }
 
 
@@ -1708,8 +1708,8 @@
   longlong val1= (*a)->val_int();
   longlong val2= (*b)->val_int();
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return test(val1 == val2);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return mysql_test(val1 == val2);
 }
 
 /**
@@ -1720,8 +1720,8 @@
   longlong val1= (*a)->val_int();
   longlong val2= (*b)->val_int();
   if ((*a)->null_value || (*b)->null_value)
-    return test((*a)->null_value && (*b)->null_value);
-  return (val1 >= 0) && test(val1 == val2);
+    return mysql_test((*a)->null_value && (*b)->null_value);
+  return (val1 >= 0) && mysql_test(val1 == val2);
 }
 
 int Arg_comparator::compare_row()
diff -ur a/sql/item_cmpfunc.h b/sql/item_cmpfunc.h
--- a/sql/item_cmpfunc.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_cmpfunc.h	2013-10-08 15:11:55.000000000 +0100
@@ -400,7 +400,7 @@
     Item_func::print_op(str, query_type);
   }
 
-  bool is_null() { return test(args[0]->is_null() || args[1]->is_null()); }
+  bool is_null() { return mysql_test(args[0]->is_null() || args[1]->is_null()); }
   const CHARSET_INFO *compare_collation()
   { return cmp.cmp_collation.collation; }
   void top_level_item() { abort_on_null= TRUE; }
@@ -950,7 +950,7 @@
   /* Compare values number pos1 and pos2 for equality */
   bool compare_elems(uint pos1, uint pos2)
   {
-    return test(compare(collation, base + pos1*size, base + pos2*size));
+    return mysql_test(compare(collation, base + pos1*size, base + pos2*size));
   }
   virtual Item_result result_type()= 0;
 };
diff -ur a/sql/item_func.cc b/sql/item_func.cc
--- a/sql/item_func.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_func.cc	2013-10-08 15:24:40.000000000 +0100
@@ -2474,7 +2474,7 @@
   case INT_RESULT:
     if ((!decimals_to_set && truncate) || (args[0]->decimal_precision() < DECIMAL_LONGLONG_DIGITS))
     {
-      int length_can_increase= test(!truncate && (val1 < 0) && !val1_unsigned);
+      int length_can_increase= mysql_test(!truncate && (val1 < 0) && !val1_unsigned);
       max_length= args[0]->max_length + length_can_increase;
       /* Here we can keep INT_RESULT */
       hybrid_type= INT_RESULT;
@@ -4555,7 +4555,7 @@
 
   mysql_cond_destroy(&cond);
 
-  return test(!error); 		// Return 1 killed
+  return mysql_test(!error); 		// Return 1 killed
 }
 
 
@@ -4726,7 +4726,7 @@
 bool user_var_entry::store(void *from, uint length, Item_result type)
 {
   // Store strings with end \0
-  if (realloc(length + test(type == STRING_RESULT)))
+  if (realloc(length + mysql_test(type == STRING_RESULT)))
     return true;
   if (type == STRING_RESULT)
     m_ptr[length]= 0;     // Store end \0
@@ -6712,7 +6712,7 @@
   max_length= sp_result_field->field_length;
   collation.set(sp_result_field->charset());
   maybe_null= 1;
-  unsigned_flag= test(sp_result_field->flags & UNSIGNED_FLAG);
+  unsigned_flag= mysql_test(sp_result_field->flags & UNSIGNED_FLAG);
 
   DBUG_VOID_RETURN;
 }
diff -ur a/sql/item_geofunc.cc b/sql/item_geofunc.cc
--- a/sql/item_geofunc.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_geofunc.cc	2013-10-08 15:24:41.000000000 +0100
@@ -261,7 +261,7 @@
   srid= uint4korr(swkb->ptr());
   str->q_append(srid);
 
-  return (null_value= test(geom->centroid(str))) ? 0 : str;
+  return (null_value= mysql_test(geom->centroid(str))) ? 0 : str;
 }
 
 
diff -ur a/sql/item_strfunc.cc b/sql/item_strfunc.cc
--- a/sql/item_strfunc.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_strfunc.cc	2013-10-08 15:24:41.000000000 +0100
@@ -100,7 +100,7 @@
   bool res= Item_func::fix_fields(thd, ref);
   /*
     In Item_str_func::check_well_formed_result() we may set null_value
-    flag on the same condition as in test() below.
+    flag on the same condition as in mysql_test() below.
   */
   maybe_null= (maybe_null || thd->is_strict_mode());
   return res;
diff -ur a/sql/item_subselect.cc b/sql/item_subselect.cc
--- a/sql/item_subselect.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_subselect.cc	2013-10-08 15:24:42.000000000 +0100
@@ -3615,7 +3615,7 @@
                          /* TODO:
                             the NULL byte is taken into account in
                             key_parts[part_no].store_length, so instead of
-                            cur_ref_buff + test(maybe_null), we could
+                            cur_ref_buff + mysql_test(maybe_null), we could
                             use that information instead.
                          */
                          cur_ref_buff + (nullable ? 1 : 0),
@@ -3724,7 +3724,7 @@
       goto err; /* purecov: inspected */
 
     materialize_engine->join->exec();
-    if ((res= test(materialize_engine->join->error || thd->is_fatal_error)))
+    if ((res= mysql_test(materialize_engine->join->error || thd->is_fatal_error)))
       goto err;
 
     /*
diff -ur a/sql/item_subselect.h b/sql/item_subselect.h
--- a/sql/item_subselect.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_subselect.h	2013-10-08 15:11:56.000000000 +0100
@@ -433,7 +433,7 @@
     if ( pushed_cond_guards)
       pushed_cond_guards[i]= v;
   }
-  bool have_guarded_conds() { return test(pushed_cond_guards); }
+  bool have_guarded_conds() { return mysql_test(pushed_cond_guards); }
 
   Item_in_subselect(Item * left_expr, st_select_lex *select_lex);
   Item_in_subselect()
diff -ur a/sql/item_sum.cc b/sql/item_sum.cc
--- a/sql/item_sum.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_sum.cc	2013-10-08 15:24:42.000000000 +0100
@@ -3426,7 +3426,7 @@
 {
   List<Item> list;
   SELECT_LEX *select_lex= thd->lex->current_select;
-  const bool order_or_distinct= test(arg_count_order > 0 || distinct);
+  const bool order_or_distinct= mysql_test(arg_count_order > 0 || distinct);
   DBUG_ENTER("Item_func_group_concat::setup");
 
   /*
diff -ur a/sql/item_timefunc.cc b/sql/item_timefunc.cc
--- a/sql/item_timefunc.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/item_timefunc.cc	2013-10-08 15:24:43.000000000 +0100
@@ -1337,7 +1337,7 @@
 
   return (longlong) calc_weekday(calc_daynr(ltime.year, ltime.month,
                                             ltime.day),
-                                 odbc_type) + test(odbc_type);
+                                 odbc_type) + mysql_test(odbc_type);
 }
 
 void Item_func_dayname::fix_length_and_dec()
diff -ur a/sql/key.cc b/sql/key.cc
--- a/sql/key.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/key.cc	2013-10-08 15:24:44.000000000 +0100
@@ -123,7 +123,7 @@
   {
     if (key_part->null_bit)
     {
-      *to_key++= test(from_record[key_part->null_offset] &
+      *to_key++= mysql_test(from_record[key_part->null_offset] &
 		   key_part->null_bit);
       key_length--;
     }
@@ -299,7 +299,7 @@
 
     if (key_part->null_bit)
     {
-      if (*key != test(table->record[0][key_part->null_offset] & 
+      if (*key != mysql_test(table->record[0][key_part->null_offset] & 
 		       key_part->null_bit))
 	return 1;
       if (*key)
@@ -438,7 +438,7 @@
       }
     }
     field_unpack(to, key_part->field, table->record[0], key_part->length,
-                 test(key_part->key_part_flag & HA_PART_KEY_SEG));
+                 mysql_test(key_part->key_part_flag & HA_PART_KEY_SEG));
   }
   dbug_tmp_restore_column_map(table->read_set, old_map);
   DBUG_VOID_RETURN;
diff -ur a/sql/log_event.cc b/sql/log_event.cc
--- a/sql/log_event.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/log_event.cc	2013-10-08 15:24:44.000000000 +0100
@@ -644,7 +644,7 @@
   {
     if (*need_comma)
       my_b_printf(file,", ");
-    my_b_printf(file,"%s=%d", name, test(flags & option));
+    my_b_printf(file,"%s=%d", name, mysql_test(flags & option));
     *need_comma= 1;
   }
 }
diff -ur a/sql/mysqld.cc b/sql/mysqld.cc
--- a/sql/mysqld.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/mysqld.cc	2013-10-08 15:24:45.000000000 +0100
@@ -8304,7 +8304,7 @@
     opt_myisam_log=1;
     break;
   case (int) OPT_BIN_LOG:
-    opt_bin_log= test(argument != disabled_my_option);
+    opt_bin_log= mysql_test(argument != disabled_my_option);
     break;
 #ifdef HAVE_REPLICATION
   case (int)OPT_REPLICATE_IGNORE_DB:
@@ -8838,7 +8838,7 @@
     Set some global variables from the global_system_variables
     In most cases the global variables will not be used
   */
-  my_disable_locking= myisam_single_user= test(opt_external_locking == 0);
+  my_disable_locking= myisam_single_user= mysql_test(opt_external_locking == 0);
   my_default_record_cache_size=global_system_variables.read_buff_size;
 
   global_system_variables.long_query_time= (ulonglong)
@@ -8865,7 +8865,7 @@
 #endif
 
   global_system_variables.engine_condition_pushdown=
-    test(global_system_variables.optimizer_switch &
+    mysql_test(global_system_variables.optimizer_switch &
          OPTIMIZER_SWITCH_ENGINE_CONDITION_PUSHDOWN);
 
   opt_readonly= read_only;
diff -ur a/sql/net_serv.cc b/sql/net_serv.cc
--- a/sql/net_serv.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/net_serv.cc	2013-10-08 15:24:46.000000000 +0100
@@ -316,7 +316,7 @@
 #ifndef DEBUG_DATA_PACKETS
   DBUG_DUMP("packet_header", buff, NET_HEADER_SIZE);
 #endif
-  rc= test(net_write_buff(net,packet,len));
+  rc= mysql_test(net_write_buff(net,packet,len));
   MYSQL_NET_WRITE_DONE(rc);
   return rc;
 }
@@ -390,7 +390,7 @@
   }
   int3store(buff,length);
   buff[3]= (uchar) net->pkt_nr++;
-  rc= test(net_write_buff(net, buff, header_size) ||
+  rc= mysql_test(net_write_buff(net, buff, header_size) ||
            (head_len && net_write_buff(net, header, head_len)) ||
            net_write_buff(net, packet, len) || net_flush(net));
   MYSQL_NET_WRITE_DONE(rc);
@@ -525,7 +525,7 @@
 #endif
   }
 
-  return test(count);
+  return mysql_test(count);
 }
 
 
@@ -700,7 +700,7 @@
 #endif
   }
 
-  return test(count);
+  return mysql_test(count);
 }
 
 
diff -ur a/sql/opt_range.cc b/sql/opt_range.cc
--- a/sql/opt_range.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/opt_range.cc	2013-10-08 15:24:46.000000000 +0100
@@ -468,7 +468,7 @@
       new_max=arg->max_value; flag_max=arg->max_flag;
     }
     return new SEL_ARG(field, part, new_min, new_max, flag_min, flag_max,
-		       test(maybe_flag && arg->maybe_flag));
+		       mysql_test(maybe_flag && arg->maybe_flag));
   }
   SEL_ARG *clone_first(SEL_ARG *arg)
   {						// min <= X < arg->min
@@ -2947,7 +2947,7 @@
     Assume that if the user is using 'limit' we will only need to scan
     limit rows if we are using a key
   */
-  DBUG_RETURN(records ? test(quick) : -1);
+  DBUG_RETURN(records ? mysql_test(quick) : -1);
 }
 
 /****************************************************************************
@@ -3077,7 +3077,7 @@
   int last_subpart_partno; /* Same as above for supartitioning */
 
   /*
-    is_part_keypart[i] == test(keypart #i in partitioning index is a member
+    is_part_keypart[i] == mysql_test(keypart #i in partitioning index is a member
                                used in partitioning)
     Used to maintain current values of cur_part_fields and cur_subpart_fields
   */
@@ -3960,7 +3960,7 @@
         ppar->mark_full_partition_used(ppar->part_info, part_id);
         found= TRUE;
       }
-      res= test(found);
+      res= mysql_test(found);
     }
     /*
       Restore the "used partitions iterator" to the default setting that
@@ -4988,7 +4988,7 @@
   SEL_ARG *sel_arg, *tuple_arg= NULL;
   key_part_map keypart_map= 0;
   bool cur_covered;
-  bool prev_covered= test(bitmap_is_set(&info->covered_fields,
+  bool prev_covered= mysql_test(bitmap_is_set(&info->covered_fields,
                                         key_part->fieldnr-1));
   key_range min_range;
   key_range max_range;
@@ -5003,7 +5003,7 @@
        sel_arg= sel_arg->next_key_part)
   {
     DBUG_PRINT("info",("sel_arg step"));
-    cur_covered= test(bitmap_is_set(&info->covered_fields,
+    cur_covered= mysql_test(bitmap_is_set(&info->covered_fields,
                                     key_part[sel_arg->part].fieldnr-1));
     if (cur_covered != prev_covered)
     {
@@ -9603,12 +9603,12 @@
   if (param->table->key_info[param->real_keynr[idx]].flags & HA_SPATIAL)
     quick=new QUICK_RANGE_SELECT_GEOM(param->thd, param->table,
                                       param->real_keynr[idx],
-                                      test(parent_alloc),
+                                      mysql_test(parent_alloc),
                                       parent_alloc, &create_err);
   else
     quick=new QUICK_RANGE_SELECT(param->thd, param->table,
                                  param->real_keynr[idx],
-                                 test(parent_alloc), NULL, &create_err);
+                                 mysql_test(parent_alloc), NULL, &create_err);
 
   if (quick)
   {
@@ -10660,7 +10660,7 @@
     const bool sorted= (mrr_flags & HA_MRR_SORTED);
     result= file->read_range_first(last_range->min_keypart_map ? &start_key : 0,
 				   last_range->max_keypart_map ? &end_key : 0,
-                                   test(last_range->flag & EQ_RANGE),
+                                   mysql_test(last_range->flag & EQ_RANGE),
 				   sorted);
     if (last_range->flag == (UNIQUE_RANGE | EQ_RANGE))
       last_range= 0;			// Stop searching
diff -ur a/sql/opt_range.h b/sql/opt_range.h
--- a/sql/opt_range.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/opt_range.h	2013-10-08 15:11:56.000000000 +0100
@@ -596,7 +596,7 @@
   THD *thd;
   int read_keys_and_merge();
 
-  bool clustered_pk_range() { return test(pk_quick_select); }
+  bool clustered_pk_range() { return mysql_test(pk_quick_select); }
 
   virtual bool is_valid()
   {
diff -ur a/sql/opt_sum.cc b/sql/opt_sum.cc
--- a/sql/opt_sum.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/opt_sum.cc	2013-10-08 15:24:47.000000000 +0100
@@ -304,7 +304,7 @@
     }
     else
     {
-      maybe_exact_count&= test(table_filled &&
+      maybe_exact_count&= mysql_test(table_filled &&
                                (tl->table->file->ha_table_flags() &
                                 HA_HAS_RECORDS));
       is_exact_count= FALSE;
@@ -379,7 +379,7 @@
       case Item_sum::MIN_FUNC:
       case Item_sum::MAX_FUNC:
       {
-        int is_max= test(item_sum->sum_func() == Item_sum::MAX_FUNC);
+        int is_max= mysql_test(item_sum->sum_func() == Item_sum::MAX_FUNC);
         /*
           If MIN/MAX(expr) is the first part of a key or if all previous
           parts of the key is found in the COND, then we can use
@@ -811,7 +811,7 @@
       Item *value= args[between && max_fl ? 2 : 1];
       value->save_in_field_no_warnings(part->field, true);
       if (part->null_bit) 
-        *key_ptr++= (uchar) test(part->field->is_null());
+        *key_ptr++= (uchar) mysql_test(part->field->is_null());
       part->field->get_key_image(key_ptr, part->length, Field::itRAW);
     }
     if (is_field_part)
@@ -831,7 +831,7 @@
   else if (eq_type)
   {
     if ((!is_null && !cond->val_int()) ||
-        (is_null && !test(part->field->is_null())))
+        (is_null && !mysql_test(part->field->is_null())))
      DBUG_RETURN(FALSE);                       // Impossible test
   }
   else if (is_field_part)
diff -ur a/sql/password.c b/sql/password.c
--- a/sql/password.c	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/password.c	2013-10-08 15:11:57.000000000 +0100
@@ -545,7 +545,7 @@
   /* now buf supposedly contains hash_stage1: so we can get hash_stage2 */
   compute_sha1_hash(hash_stage2_reassured, (const char *) buf, SHA1_HASH_SIZE);
 
-  return test(memcmp(hash_stage2, hash_stage2_reassured, SHA1_HASH_SIZE));
+  return mysql_test(memcmp(hash_stage2, hash_stage2_reassured, SHA1_HASH_SIZE));
 }
 
 my_bool
diff -ur a/sql/rpl_mi.cc b/sql/rpl_mi.cc
--- a/sql/rpl_mi.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/rpl_mi.cc	2013-10-08 15:24:48.000000000 +0100
@@ -478,10 +478,10 @@
       DBUG_RETURN(true);
   }
 
-  ssl= (my_bool) test(temp_ssl);
-  ssl_verify_server_cert= (my_bool) test(temp_ssl_verify_server_cert);
+  ssl= (my_bool) mysql_test(temp_ssl);
+  ssl_verify_server_cert= (my_bool) mysql_test(temp_ssl_verify_server_cert);
   master_log_pos= (my_off_t) temp_master_log_pos;
-  auto_position= test(temp_auto_position);
+  auto_position= mysql_test(temp_auto_position);
 
   if (auto_position != 0 && gtid_mode != 3)
   {
diff -ur a/sql/rpl_slave.cc b/sql/rpl_slave.cc
--- a/sql/rpl_slave.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/rpl_slave.cc	2013-10-08 15:24:48.000000000 +0100
@@ -3557,7 +3557,7 @@
         "skipped because event skip counter was non-zero"
       };
       DBUG_PRINT("info", ("OPTION_BEGIN: %d; IN_STMT: %d",
-                          test(thd->variables.option_bits & OPTION_BEGIN),
+                          mysql_test(thd->variables.option_bits & OPTION_BEGIN),
                           rli->get_flag(Relay_log_info::IN_STMT)));
       DBUG_PRINT("skip_event", ("%s event was %s",
                                 ev->get_type_str(), explain[reason]));
diff -ur a/sql/set_var.cc b/sql/set_var.cc
--- a/sql/set_var.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/set_var.cc	2013-10-08 15:24:49.000000000 +0100
@@ -566,7 +566,7 @@
     if ((error= var->check(thd)))
       goto err;
   }
-  if (!(error= test(thd->is_error())))
+  if (!(error= mysql_test(thd->is_error())))
   {
     it.rewind();
     while ((var= it++))
diff -ur a/sql/sp_head.h b/sql/sp_head.h
--- a/sql/sp_head.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sp_head.h	2013-10-08 15:11:57.000000000 +0100
@@ -859,7 +859,7 @@
     else if (m_flags & HAS_SQLCOM_FLUSH)
       my_error(ER_STMT_NOT_ALLOWED_IN_SF_OR_TRG, MYF(0), "FLUSH");
 
-    return test(m_flags &
+    return mysql_test(m_flags &
 		(CONTAINS_DYNAMIC_SQL|MULTI_RESULTS|HAS_SET_AUTOCOMMIT_STMT|
                  HAS_COMMIT_OR_ROLLBACK|HAS_SQLCOM_RESET|HAS_SQLCOM_FLUSH));
   }
diff -ur a/sql/sp_rcontext.h b/sql/sp_rcontext.h
--- a/sql/sp_rcontext.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sp_rcontext.h	2013-10-08 15:11:57.000000000 +0100
@@ -453,7 +453,7 @@
   bool close(THD *thd);
 
   bool is_open() const
-  { return test(m_server_side_cursor); }
+  { return mysql_test(m_server_side_cursor); }
 
   bool fetch(THD *thd, List<sp_variable> *vars);
 
diff -ur a/sql/sql_acl.cc b/sql/sql_acl.cc
--- a/sql/sql_acl.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_acl.cc	2013-10-08 15:24:49.000000000 +0100
@@ -2863,9 +2863,9 @@
 static bool test_if_create_new_users(THD *thd)
 {
   Security_context *sctx= thd->security_ctx;
-  bool create_new_users= test(sctx->master_access & INSERT_ACL) ||
+  bool create_new_users= mysql_test(sctx->master_access & INSERT_ACL) ||
                          (!opt_safe_user_create &&
-                          test(sctx->master_access & CREATE_USER_ACL));
+                          mysql_test(sctx->master_access & CREATE_USER_ACL));
   if (!create_new_users)
   {
     TABLE_LIST tl;
@@ -4639,7 +4639,7 @@
     /* Create user if needed */
     error=replace_user_table(thd, tables[0].table, Str,
 			     0, revoke_grant, create_new_users,
-                             test(thd->variables.sql_mode &
+                             mysql_test(thd->variables.sql_mode &
                                   MODE_NO_AUTO_CREATE_USER));
     if (error)
     {
@@ -4884,7 +4884,7 @@
     /* Create user if needed */
     error=replace_user_table(thd, tables[0].table, Str,
 			     0, revoke_grant, create_new_users,
-                             test(thd->variables.sql_mode &
+                             mysql_test(thd->variables.sql_mode &
                                   MODE_NO_AUTO_CREATE_USER));
     if (error)
     {
@@ -5161,7 +5161,7 @@
  
     if (replace_user_table(thd, tables[0].table, Str,
                            (!db ? rights : 0), revoke_grant, create_new_users,
-                           test(thd->variables.sql_mode &
+                           mysql_test(thd->variables.sql_mode &
                                 MODE_NO_AUTO_CREATE_USER)))
       result= -1;
     else if (db)
@@ -5660,7 +5660,7 @@
        tl && number-- && tl != first_not_own_table;
        tl= tl->next_global)
   {
-    sctx = test(tl->security_ctx) ? tl->security_ctx : thd->security_ctx;
+    sctx = mysql_test(tl->security_ctx) ? tl->security_ctx : thd->security_ctx;
 
     const ACL_internal_table_access *access=
       get_cached_table_access(&tl->grant.m_internal,
@@ -5870,7 +5870,7 @@
   GRANT_INFO *grant;
   const char *db_name;
   const char *table_name;
-  Security_context *sctx= test(table_ref->security_ctx) ?
+  Security_context *sctx= mysql_test(table_ref->security_ctx) ?
                           table_ref->security_ctx : thd->security_ctx;
 
   if (table_ref->view || table_ref->field_translation)
diff -ur a/sql/sql_admin.cc b/sql/sql_admin.cc
--- a/sql/sql_admin.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_admin.cc	2013-10-08 15:24:50.000000000 +0100
@@ -1123,7 +1123,7 @@
   thd->enable_slow_log= opt_log_slow_admin_statements;
   res= mysql_admin_table(thd, first_table, &thd->lex->check_opt, "repair",
                          TL_WRITE, 1,
-                         test(thd->lex->check_opt.sql_flags & TT_USEFRM),
+                         mysql_test(thd->lex->check_opt.sql_flags & TT_USEFRM),
                          HA_OPEN_FOR_REPAIR, &prepare_for_repair,
                          &handler::ha_repair, 0);
 
diff -ur a/sql/sql_base.cc b/sql/sql_base.cc
--- a/sql/sql_base.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_base.cc	2013-10-08 15:24:51.000000000 +0100
@@ -1612,7 +1612,7 @@
 
   /* We always quote db,table names though it is slight overkill */
   if (found_user_tables &&
-      !(was_quote_show= test(thd->variables.option_bits & OPTION_QUOTE_SHOW_CREATE)))
+      !(was_quote_show= mysql_test(thd->variables.option_bits & OPTION_QUOTE_SHOW_CREATE)))
   {
     thd->variables.option_bits |= OPTION_QUOTE_SHOW_CREATE;
   }
@@ -8241,7 +8241,7 @@
   thd->lex->allow_sum_func= save_allow_sum_func;
   thd->mark_used_columns= save_mark_used_columns;
   DBUG_PRINT("info", ("thd->mark_used_columns: %d", thd->mark_used_columns));
-  DBUG_RETURN(test(thd->is_error()));
+  DBUG_RETURN(mysql_test(thd->is_error()));
 }
 
 
@@ -8805,7 +8805,7 @@
   }
 
   thd->lex->current_select->is_item_list_lookup= save_is_item_list_lookup;
-  DBUG_RETURN(test(thd->is_error()));
+  DBUG_RETURN(mysql_test(thd->is_error()));
 
 err_no_arena:
   select_lex->is_item_list_lookup= save_is_item_list_lookup;
diff -ur a/sql/sql_bitmap.h b/sql/sql_bitmap.h
--- a/sql/sql_bitmap.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_bitmap.h	2013-10-08 15:11:57.000000000 +0100
@@ -60,7 +60,7 @@
     intersect(map2buff);
     if (map.n_bits > sizeof(ulonglong) * 8)
       bitmap_set_above(&map, sizeof(ulonglong),
-                       test(map2buff & (LL(1) << (sizeof(ulonglong) * 8 - 1))));
+                       mysql_test(map2buff & (LL(1) << (sizeof(ulonglong) * 8 - 1))));
   }
   void subtract(const Bitmap& map2) { bitmap_subtract(&map, &map2.map); }
   void merge(const Bitmap& map2) { bitmap_union(&map, &map2.map); }
@@ -135,7 +135,7 @@
   void intersect_extended(ulonglong map2) { map&= map2; }
   void subtract(const Bitmap<64>& map2) { map&= ~map2.map; }
   void merge(const Bitmap<64>& map2) { map|= map2.map; }
-  my_bool is_set(uint n) const { return test(map & (((ulonglong)1) << n)); }
+  my_bool is_set(uint n) const { return mysql_test(map & (((ulonglong)1) << n)); }
   my_bool is_prefix(uint n) const { return map == (((ulonglong)1) << n)-1; }
   my_bool is_clear_all() const { return map == (ulonglong)0; }
   my_bool is_set_all() const { return map == ~(ulonglong)0; }
diff -ur a/sql/sql_cache.cc b/sql/sql_cache.cc
--- a/sql/sql_cache.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_cache.cc	2013-10-08 15:24:51.000000000 +0100
@@ -1209,8 +1209,8 @@
     Query_cache_query_flags flags;
     // fill all gaps between fields with 0 to get repeatable key
     memset(&flags, 0, QUERY_CACHE_FLAGS_SIZE);
-    flags.client_long_flag= test(thd->client_capabilities & CLIENT_LONG_FLAG);
-    flags.client_protocol_41= test(thd->client_capabilities &
+    flags.client_long_flag= mysql_test(thd->client_capabilities & CLIENT_LONG_FLAG);
+    flags.client_protocol_41= mysql_test(thd->client_capabilities &
                                    CLIENT_PROTOCOL_41);
     /*
       Protocol influences result format, so statement results in the binary
@@ -1220,10 +1220,10 @@
     flags.protocol_type= (unsigned int) thd->protocol->type();
     /* PROTOCOL_LOCAL results are not cached. */
     DBUG_ASSERT(flags.protocol_type != (unsigned int) Protocol::PROTOCOL_LOCAL);
-    flags.more_results_exists= test(thd->server_status &
+    flags.more_results_exists= mysql_test(thd->server_status &
                                     SERVER_MORE_RESULTS_EXISTS);
     flags.in_trans= thd->in_active_multi_stmt_transaction();
-    flags.autocommit= test(thd->server_status & SERVER_STATUS_AUTOCOMMIT);
+    flags.autocommit= mysql_test(thd->server_status & SERVER_STATUS_AUTOCOMMIT);
     flags.pkt_nr= net->pkt_nr;
     flags.character_set_client_num=
       thd->variables.character_set_client->number;
@@ -1595,14 +1595,14 @@
 
   // fill all gaps between fields with 0 to get repeatable key
   memset(&flags, 0, QUERY_CACHE_FLAGS_SIZE);
-  flags.client_long_flag= test(thd->client_capabilities & CLIENT_LONG_FLAG);
-  flags.client_protocol_41= test(thd->client_capabilities &
+  flags.client_long_flag= mysql_test(thd->client_capabilities & CLIENT_LONG_FLAG);
+  flags.client_protocol_41= mysql_test(thd->client_capabilities &
                                  CLIENT_PROTOCOL_41);
   flags.protocol_type= (unsigned int) thd->protocol->type();
-  flags.more_results_exists= test(thd->server_status &
+  flags.more_results_exists= mysql_test(thd->server_status &
                                   SERVER_MORE_RESULTS_EXISTS);
   flags.in_trans= thd->in_active_multi_stmt_transaction();
-  flags.autocommit= test(thd->server_status & SERVER_STATUS_AUTOCOMMIT);
+  flags.autocommit= mysql_test(thd->server_status & SERVER_STATUS_AUTOCOMMIT);
   flags.pkt_nr= thd->net.pkt_nr;
   flags.character_set_client_num= thd->variables.character_set_client->number;
   flags.character_set_results_num=
@@ -3051,7 +3051,7 @@
 	 tmp++)
       unlink_table(tmp);
   }
-  return test(n);
+  return mysql_test(n);
 }
 
 
diff -ur a/sql/sql_class.cc b/sql/sql_class.cc
--- a/sql/sql_class.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_class.cc	2013-10-08 15:24:52.000000000 +0100
@@ -553,14 +553,14 @@
 extern "C"
 int thd_in_lock_tables(const THD *thd)
 {
-  return test(thd->in_lock_tables);
+  return mysql_test(thd->in_lock_tables);
 }
 
 
 extern "C"
 int thd_tablespace_op(const THD *thd)
 {
-  return test(thd->tablespace_op);
+  return mysql_test(thd->tablespace_op);
 }
 
 
@@ -2541,7 +2541,7 @@
 
 bool select_to_file::send_eof()
 {
-  int error= test(end_io_cache(&cache));
+  int error= mysql_test(end_io_cache(&cache));
   if (mysql_file_close(file, MYF(MY_WME)) || thd->is_error())
     error= true;
 
@@ -2722,8 +2722,8 @@
     escape_char= (int) (uchar) (*exchange->escaped)[0];
   else
     escape_char= -1;
-  is_ambiguous_field_sep= test(strchr(ESCAPE_CHARS, field_sep_char));
-  is_unsafe_field_sep= test(strchr(NUMERIC_CHARS, field_sep_char));
+  is_ambiguous_field_sep= mysql_test(strchr(ESCAPE_CHARS, field_sep_char));
+  is_unsafe_field_sep= mysql_test(strchr(NUMERIC_CHARS, field_sep_char));
   line_sep_char= (exchange->line_term->length() ?
                  (int) (uchar) (*exchange->line_term)[0] : INT_MAX);
   if (!field_term_length)
diff -ur a/sql/sql_class.h b/sql/sql_class.h
--- a/sql/sql_class.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_class.h	2013-10-08 15:11:57.000000000 +0100
@@ -3193,7 +3193,7 @@
   }
   inline bool is_strict_mode() const
   {
-    return test(variables.sql_mode & (MODE_STRICT_TRANS_TABLES |
+    return mysql_test(variables.sql_mode & (MODE_STRICT_TRANS_TABLES |
                                       MODE_STRICT_ALL_TABLES));
   }
   inline Time_zone *time_zone()
@@ -4662,7 +4662,7 @@
     table.str= internal_table_name;
     table.length=1;
   }
-  bool is_derived_table() const { return test(sel); }
+  bool is_derived_table() const { return mysql_test(sel); }
   inline void change_db(char *db_name)
   {
     db.str= db_name; db.length= (uint) strlen(db_name);
diff -ur a/sql/sql_delete.cc b/sql/sql_delete.cc
--- a/sql/sql_delete.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_delete.cc	2013-10-08 15:24:53.000000000 +0100
@@ -119,7 +119,7 @@
     DBUG_RETURN(true);
 
   const_cond= (!conds || conds->const_item());
-  safe_update=test(thd->variables.option_bits & OPTION_SAFE_UPDATES);
+  safe_update=mysql_test(thd->variables.option_bits & OPTION_SAFE_UPDATES);
   if (safe_update && const_cond)
   {
     my_message(ER_UPDATE_WITHOUT_KEY_IN_SAFE_MODE,
diff -ur a/sql/sql_executor.cc b/sql/sql_executor.cc
--- a/sql/sql_executor.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_executor.cc	2013-10-08 15:24:53.000000000 +0100
@@ -1455,7 +1455,7 @@
 
   if (condition)
   {
-    found= test(condition->val_int());
+    found= mysql_test(condition->val_int());
 
     if (join->thd->killed)
     {
@@ -1863,7 +1863,7 @@
   {
     // We cannot handle outer-joined tables with expensive join conditions here:
     DBUG_ASSERT(!(*tab->on_expr_ref)->is_expensive());
-    if ((table->null_row= test((*tab->on_expr_ref)->val_int() == 0)))
+    if ((table->null_row= mysql_test((*tab->on_expr_ref)->val_int() == 0)))
       mark_as_null_row(table);  
   }
   if (!table->null_row)
diff -ur a/sql/sql_insert.cc b/sql/sql_insert.cc
--- a/sql/sql_insert.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_insert.cc	2013-10-08 15:24:54.000000000 +0100
@@ -793,7 +793,7 @@
                                            update,
                                            update_fields,
                                            fields,
-                                           !test(values->elements),
+                                           !mysql_test(values->elements),
                                            &can_prune_partitions,
                                            &prune_needs_default_values,
                                            &used_partitions))
@@ -1978,7 +1978,7 @@
       if (table_list)
       {
         table_list= table_list->top_table();
-        view= test(table_list->view);
+        view= mysql_test(table_list->view);
       }
       if (view)
       {
@@ -3979,7 +3979,7 @@
 
   tmp_table.s->db_create_options=0;
   tmp_table.s->db_low_byte_first= 
-        test(create_info->db_type == myisam_hton ||
+        mysql_test(create_info->db_type == myisam_hton ||
              create_info->db_type == heap_hton);
   tmp_table.null_row=tmp_table.maybe_null=0;
 
diff -ur a/sql/sql_join_buffer.cc b/sql/sql_join_buffer.cc
--- a/sql/sql_join_buffer.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_join_buffer.cc	2013-10-08 15:24:54.000000000 +0100
@@ -184,8 +184,8 @@
   for ( ; tab < join_tab ; tab++)
   {	    
     calc_used_field_length(join->thd, tab);
-    flag_fields+= test(tab->used_null_fields || tab->used_uneven_bit_fields);
-    flag_fields+= test(tab->table->maybe_null);
+    flag_fields+= mysql_test(tab->used_null_fields || tab->used_uneven_bit_fields);
+    flag_fields+= mysql_test(tab->table->maybe_null);
     fields+= tab->used_fields;
     blobs+= tab->used_blobs;
 
@@ -1350,7 +1350,7 @@
 bool JOIN_CACHE::get_match_flag_by_pos(uchar *rec_ptr)
 {
   if (with_match_flag)
-    return test(*rec_ptr);
+    return mysql_test(*rec_ptr);
   if (prev_cache)
   {
     uchar *prev_rec_ptr= prev_cache->get_rec_ref(rec_ptr);
@@ -1593,7 +1593,7 @@
   if (prev_cache)
     offset+= prev_cache->get_size_of_rec_offset();
   /* Check whether the match flag is on */
-  if (test(*(pos+offset)))
+  if (mysql_test(*(pos+offset)))
   {
     pos+= size_of_rec_len + get_rec_length(pos);
     return TRUE;
@@ -1886,7 +1886,7 @@
         reset_cache(false);
 
         /* Read each record from the join buffer and look for matches */
-        for (cnt= records - test(skip_last) ; cnt; cnt--)
+        for (cnt= records - mysql_test(skip_last) ; cnt; cnt--)
         { 
           /* 
             If only the first match is needed and it has been already found for
@@ -2131,7 +2131,7 @@
   if (!records)
     DBUG_RETURN(NESTED_LOOP_OK);
   
-  cnt= records - (is_key_access() ? 0 : test(skip_last));
+  cnt= records - (is_key_access() ? 0 : mysql_test(skip_last));
 
   /* This function may be called only for inner tables of outer joins */ 
   DBUG_ASSERT(join_tab->first_inner);
diff -ur a/sql/sql_lex.cc b/sql/sql_lex.cc
--- a/sql/sql_lex.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_lex.cc	2013-10-08 15:24:55.000000000 +0100
@@ -248,7 +248,7 @@
   m_cpp_utf8_processed_ptr= NULL;
   next_state= MY_LEX_START;
   found_semicolon= NULL;
-  ignore_space= test(m_thd->variables.sql_mode & MODE_IGNORE_SPACE);
+  ignore_space= mysql_test(m_thd->variables.sql_mode & MODE_IGNORE_SPACE);
   stmt_prepare_mode= FALSE;
   multi_statements= TRUE;
   in_comment=NO_COMMENT;
@@ -3380,7 +3380,7 @@
     /*
       and from local list if it is not empty
     */
-    if ((*link_to_local= test(select_lex.table_list.first)))
+    if ((*link_to_local= mysql_test(select_lex.table_list.first)))
     {
       select_lex.context.table_list= 
         select_lex.context.first_name_resolution_table= first->next_local;
diff -ur a/sql/sql_lex.h b/sql/sql_lex.h
--- a/sql/sql_lex.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_lex.h	2013-10-08 15:11:59.000000000 +0100
@@ -1207,7 +1207,7 @@
   }
   bool requires_prelocking()
   {
-    return test(query_tables_own_last);
+    return mysql_test(query_tables_own_last);
   }
   void mark_as_requiring_prelocking(TABLE_LIST **tables_own_last)
   {
diff -ur a/sql/sql_load.cc b/sql/sql_load.cc
--- a/sql/sql_load.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_load.cc	2013-10-08 15:24:56.000000000 +0100
@@ -475,7 +475,7 @@
     }
   }
 
-  if (!(error=test(read_info.error)))
+  if (!(error=mysql_test(read_info.error)))
   {
 
     table->next_number_field=table->found_next_number_field;
@@ -919,7 +919,7 @@
     thd->get_stmt_da()->inc_current_row_for_warning();
 continue_loop:;
   }
-  DBUG_RETURN(test(read_info.error));
+  DBUG_RETURN(mysql_test(read_info.error));
 }
 
 
@@ -1138,7 +1138,7 @@
     thd->get_stmt_da()->inc_current_row_for_warning();
 continue_loop:;
   }
-  DBUG_RETURN(test(read_info.error));
+  DBUG_RETURN(mysql_test(read_info.error));
 }
 
 
@@ -1309,7 +1309,7 @@
     thd->get_stmt_da()->inc_current_row_for_warning();
     continue_loop:;
   }
-  DBUG_RETURN(test(read_info.error) || thd->is_error());
+  DBUG_RETURN(mysql_test(read_info.error) || thd->is_error());
 } /* load xml end */
 
 
diff -ur a/sql/sql_optimizer.cc b/sql/sql_optimizer.cc
--- a/sql/sql_optimizer.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_optimizer.cc	2013-10-08 15:24:57.000000000 +0100
@@ -752,13 +752,13 @@
   need_tmp= ((!plan_is_const() &&
 	     ((select_distinct || !simple_order || !simple_group) ||
 	      (group_list && order) ||
-	      test(select_options & OPTION_BUFFER_RESULT))) ||
+	      mysql_test(select_options & OPTION_BUFFER_RESULT))) ||
              (rollup.state != ROLLUP::STATE_NONE && select_distinct));
 
   /* Perform FULLTEXT search before all regular searches */
   if (!(select_options & SELECT_DESCRIBE))
   {
-    init_ftfuncs(thd, select_lex, test(order));
+    init_ftfuncs(thd, select_lex, mysql_test(order));
     optimize_fts_query();
   }
 
@@ -2517,7 +2517,7 @@
   NESTED_JOIN *nested_join;
   TABLE_LIST *prev_table= 0;
   List_iterator<TABLE_LIST> li(*join_list);
-  bool straight_join= test(join->select_options & SELECT_STRAIGHT_JOIN);
+  bool straight_join= mysql_test(join->select_options & SELECT_STRAIGHT_JOIN);
   DBUG_ENTER("simplify_joins");
 
   /* 
@@ -5429,8 +5429,8 @@
   if (a->keypart != b->keypart)
     return (int) (a->keypart - b->keypart);
   // Place const values before other ones
-  if ((res= test((a->used_tables & ~OUTER_REF_TABLE_BIT)) -
-       test((b->used_tables & ~OUTER_REF_TABLE_BIT))))
+  if ((res= mysql_test((a->used_tables & ~OUTER_REF_TABLE_BIT)) -
+       mysql_test((b->used_tables & ~OUTER_REF_TABLE_BIT))))
     return res;
   /* Place rows that are not 'OPTIMIZE_REF_OR_NULL' first */
   return (int) ((a->optimize & KEY_OPTIMIZE_REF_OR_NULL) -
diff -ur a/sql/sql_optimizer.h b/sql/sql_optimizer.h
--- a/sql/sql_optimizer.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_optimizer.h	2013-10-08 15:12:00.000000000 +0100
@@ -433,7 +433,7 @@
     result= result_arg;
     lock= thd_arg->lock;
     select_lex= 0; //for safety
-    select_distinct= test(select_options & SELECT_DISTINCT);
+    select_distinct= mysql_test(select_options & SELECT_DISTINCT);
     no_order= 0;
     simple_order= 0;
     simple_group= 0;
diff -ur a/sql/sql_parse.cc b/sql/sql_parse.cc
--- a/sql/sql_parse.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_parse.cc	2013-10-08 15:24:58.000000000 +0100
@@ -6470,7 +6470,7 @@
   if (!table)
     DBUG_RETURN(0);				// End of memory
   alias_str= alias ? alias->str : table->table.str;
-  if (!test(table_options & TL_OPTION_ALIAS))
+  if (!mysql_test(table_options & TL_OPTION_ALIAS))
   {
     enum_ident_name_check ident_check_status=
       check_table_name(table->table.str, table->table.length, FALSE);
@@ -6520,10 +6520,10 @@
   ptr->table_name=table->table.str;
   ptr->table_name_length=table->table.length;
   ptr->lock_type=   lock_type;
-  ptr->updating=    test(table_options & TL_OPTION_UPDATING);
+  ptr->updating=    mysql_test(table_options & TL_OPTION_UPDATING);
   /* TODO: remove TL_OPTION_FORCE_INDEX as it looks like it's not used */
-  ptr->force_index= test(table_options & TL_OPTION_FORCE_INDEX);
-  ptr->ignore_leaves= test(table_options & TL_OPTION_IGNORE_LEAVES);
+  ptr->force_index= mysql_test(table_options & TL_OPTION_FORCE_INDEX);
+  ptr->ignore_leaves= mysql_test(table_options & TL_OPTION_IGNORE_LEAVES);
   ptr->derived=	    table->sel;
   if (!ptr->derived && is_infoschema_db(ptr->db, ptr->db_length))
   {
@@ -6614,7 +6614,7 @@
   lex->add_to_query_tables(ptr);
 
   // Pure table aliases do not need to be locked:
-  if (!test(table_options & TL_OPTION_ALIAS))
+  if (!mysql_test(table_options & TL_OPTION_ALIAS))
   {
     ptr->mdl_request.init(MDL_key::TABLE, ptr->db, ptr->table_name, mdl_type,
                           MDL_TRANSACTION);
diff -ur a/sql/sql_partition.cc b/sql/sql_partition.cc
--- a/sql/sql_partition.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_partition.cc	2013-10-08 15:25:00.000000000 +0100
@@ -3377,7 +3377,7 @@
     }
     else 
     {
-      DBUG_RETURN(list_index + test(left_endpoint ^ include_endpoint));
+      DBUG_RETURN(list_index + mysql_test(left_endpoint ^ include_endpoint));
     }
   } while (max_list_index >= min_list_index);
 notfound:
@@ -5853,7 +5853,7 @@
   if (mysql_trans_commit_alter_copy_data(thd))
     error= 1;                                /* The error has been reported */
 
-  DBUG_RETURN(test(error));
+  DBUG_RETURN(mysql_test(error));
 }
 
 
@@ -7967,7 +7967,7 @@
         index-in-ordered-array-of-list-constants (for LIST) space.
       */
       store_key_image_to_rec(field, min_value, field_len);
-      bool include_endp= !test(flags & NEAR_MIN);
+      bool include_endp= !mysql_test(flags & NEAR_MIN);
       part_iter->part_nums.start= get_endpoint(part_info, 1, include_endp);
       if (!can_match_multiple_values && part_info->part_expr->null_value)
       {
@@ -8002,7 +8002,7 @@
   else
   {
     store_key_image_to_rec(field, max_value, field_len);
-    bool include_endp= !test(flags & NEAR_MAX);
+    bool include_endp= !mysql_test(flags & NEAR_MAX);
     part_iter->part_nums.end= get_endpoint(part_info, 0, include_endp);
     if (check_zero_dates &&
         !zero_in_start_date &&
@@ -8169,8 +8169,8 @@
   if ((ulonglong)b - (ulonglong)a == ~0ULL)
     DBUG_RETURN(-1);
 
-  a += test(flags & NEAR_MIN);
-  b += test(!(flags & NEAR_MAX));
+  a += mysql_test(flags & NEAR_MIN);
+  b += mysql_test(!(flags & NEAR_MAX));
   ulonglong n_values= b - a;
 
   /*
diff -ur a/sql/sql_planner.cc b/sql/sql_planner.cc
--- a/sql/sql_planner.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_planner.cc	2013-10-08 15:25:00.000000000 +0100
@@ -193,7 +193,7 @@
     }
   }
 
-  bool have_a_case() { return test(handled_sj_equalities); }
+  bool have_a_case() { return mysql_test(handled_sj_equalities); }
 
   /**
     Check if an index can be used for LooseScan, part 1
@@ -571,7 +571,7 @@
       }
       else
       {
-        found_constraint= test(found_part);
+        found_constraint= mysql_test(found_part);
         loose_scan_opt.check_ref_access_part1(s, key, start_key, found_part);
 
         /* Check if we found full key */
@@ -711,7 +711,7 @@
             */
             if (table->quick_keys.is_set(key) && !found_ref &&          //(C1)
                 table->quick_key_parts[key] == max_key_part &&          //(C2)
-                table->quick_n_ranges[key] == 1+test(ref_or_null_part)) //(C3)
+                table->quick_n_ranges[key] == 1+mysql_test(ref_or_null_part)) //(C3)
             {
               tmp= records= (double) table->quick_rows[key];
             }
@@ -813,7 +813,7 @@
                   table->quick_key_parts[key] <= max_key_part &&
                   const_part &
                     ((key_part_map)1 << table->quick_key_parts[key]) &&
-                  table->quick_n_ranges[key] == 1 + test(ref_or_null_part &
+                  table->quick_n_ranges[key] == 1 + mysql_test(ref_or_null_part &
                                                          const_part) &&
                   records > (double) table->quick_rows[key])
               {
@@ -1037,7 +1037,7 @@
       best_key= 0;
       /* range/index_merge/ALL/index access method are "independent", so: */
       best_ref_depends_map= 0;
-      best_uses_jbuf= test(!disable_jbuf);
+      best_uses_jbuf= mysql_test(!disable_jbuf);
     }
   }
 
@@ -1101,7 +1101,7 @@
 
   reset_nj_counters(join->join_list);
 
-  const bool straight_join= test(join->select_options & SELECT_STRAIGHT_JOIN);
+  const bool straight_join= mysql_test(join->select_options & SELECT_STRAIGHT_JOIN);
   table_map join_tables;      ///< The tables involved in order selection
 
   if (emb_sjm_nest)
diff -ur a/sql/sql_prepare.cc b/sql/sql_prepare.cc
--- a/sql/sql_prepare.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_prepare.cc	2013-10-08 15:25:01.000000000 +0100
@@ -981,7 +981,7 @@
 
       typecode= sint2korr(read_pos);
       read_pos+= 2;
-      (**it).unsigned_flag= test(typecode & signed_bit);
+      (**it).unsigned_flag= mysql_test(typecode & signed_bit);
       setup_one_conversion_function(thd, *it, (uchar) (typecode & ~signed_bit));
     }
   }
@@ -2664,7 +2664,7 @@
   DBUG_PRINT("exec_query", ("%s", stmt->query()));
   DBUG_PRINT("info",("stmt: 0x%lx", (long) stmt));
 
-  open_cursor= test(flags & (ulong) CURSOR_TYPE_READ_ONLY);
+  open_cursor= mysql_test(flags & (ulong) CURSOR_TYPE_READ_ONLY);
 
   thd->protocol= &thd->protocol_binary;
   stmt->execute_loop(&expanded_query, open_cursor, packet, packet_end);
diff -ur a/sql/sql_prepare.h b/sql/sql_prepare.h
--- a/sql/sql_prepare.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_prepare.h	2013-10-08 15:12:00.000000000 +0100
@@ -289,7 +289,7 @@
     one.
     Never fails.
   */
-  bool has_next_result() const { return test(m_current_rset->m_next_rset); }
+  bool has_next_result() const { return mysql_test(m_current_rset->m_next_rset); }
   /**
     Only valid to call if has_next_result() returned true.
     Otherwise the result is undefined.
@@ -297,7 +297,7 @@
   bool move_to_next_result()
   {
     m_current_rset= m_current_rset->m_next_rset;
-    return test(m_current_rset);
+    return mysql_test(m_current_rset);
   }
 
   ~Ed_connection() { free_old_result(); }
diff -ur a/sql/sql_select.cc b/sql/sql_select.cc
--- a/sql/sql_select.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_select.cc	2013-10-08 15:25:01.000000000 +0100
@@ -789,7 +789,7 @@
   }
 
   if (!(select_options & SELECT_DESCRIBE))
-    init_ftfuncs(thd, select_lex, test(order));
+    init_ftfuncs(thd, select_lex, mysql_test(order));
 
   DBUG_VOID_RETURN;
 }
@@ -931,7 +931,7 @@
   sjm_exec_list.empty();
 
   keyuse.clear();
-  DBUG_RETURN(test(error));
+  DBUG_RETURN(mysql_test(error));
 }
 
 
@@ -1690,7 +1690,7 @@
     for (uint part_no= 0 ; part_no < keyparts ; part_no++)
     {
       keyuse= chosen_keyuses[part_no];
-      uint maybe_null= test(keyinfo->key_part[part_no].null_bit);
+      uint maybe_null= mysql_test(keyinfo->key_part[part_no].null_bit);
 
       if (keyuse->val->type() == Item::FIELD_ITEM)
       {
@@ -1928,7 +1928,7 @@
 	  new_cond->argument_list()->push_back(fix);
           used_tables|= fix->used_tables();
         }
-        n_marked += test(item->marker == ICP_COND_USES_INDEX_ONLY);
+        n_marked += mysql_test(item->marker == ICP_COND_USES_INDEX_ONLY);
       }
       if (n_marked ==((Item_cond*)cond)->argument_list()->elements)
         cond->marker= ICP_COND_USES_INDEX_ONLY;
@@ -1957,7 +1957,7 @@
 	if (!fix)
 	  return NULL;
 	new_cond->argument_list()->push_back(fix);
-        n_marked += test(item->marker == ICP_COND_USES_INDEX_ONLY);
+        n_marked += mysql_test(item->marker == ICP_COND_USES_INDEX_ONLY);
       }
       if (n_marked ==((Item_cond*)cond)->argument_list()->elements)
         cond->marker= ICP_COND_USES_INDEX_ONLY;
@@ -2762,7 +2762,7 @@
 bool
 make_join_readinfo(JOIN *join, ulonglong options, uint no_jbuf_after)
 {
-  const bool statistics= test(!(join->select_options & SELECT_DESCRIBE));
+  const bool statistics= mysql_test(!(join->select_options & SELECT_DESCRIBE));
 
   DBUG_ENTER("make_join_readinfo");
 
@@ -4431,7 +4431,7 @@
     else
       return 0;
   }
-  return test(!b);
+  return mysql_test(!b);
 }
 
 /**
@@ -5181,7 +5181,7 @@
         or end_write_group()) if JOIN::group is set to false.
       */
       // the temporary table was explicitly requested
-      DBUG_ASSERT(test(select_options & OPTION_BUFFER_RESULT));
+      DBUG_ASSERT(mysql_test(select_options & OPTION_BUFFER_RESULT));
       // the temporary table does not have a grouping expression
       DBUG_ASSERT(!join_tab[curr_tmp_table].table->group); 
     }
diff -ur a/sql/sql_select.h b/sql/sql_select.h
--- a/sql/sql_select.h	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_select.h	2013-10-08 15:12:00.000000000 +0100
@@ -808,7 +808,7 @@
       used_rowid_fields= 1;
       used_fieldlength+= table->file->ref_length;
     }
-    return test(used_rowid_fields);
+    return mysql_test(used_rowid_fields);
   }
   bool is_inner_table_of_outer_join()
   {
diff -ur a/sql/sql_show.cc b/sql/sql_show.cc
--- a/sql/sql_show.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_show.cc	2013-10-08 15:25:02.000000000 +0100
@@ -740,7 +740,7 @@
     m_view_access_denied_message_ptr(NULL) 
   {
     
-    m_sctx = test(m_top_view->security_ctx) ?
+    m_sctx = mysql_test(m_top_view->security_ctx) ?
       m_top_view->security_ctx : thd->security_ctx;
   }
 
@@ -1835,7 +1835,7 @@
       end= longlong10_to_str(key_info->block_size, buff, 10);
       packet->append(buff, (uint) (end - buff));
     }
-    DBUG_ASSERT(test(key_info->flags & HA_USES_COMMENT) == 
+    DBUG_ASSERT(mysql_test(key_info->flags & HA_USES_COMMENT) == 
                (key_info->comment.length > 0));
     if (key_info->flags & HA_USES_COMMENT)
     {
@@ -4642,7 +4642,7 @@
 #ifndef NO_EMBEDDED_ACCESS_CHECKS
     uint col_access;
     check_access(thd,SELECT_ACL, db_name->str,
-                 &tables->grant.privilege, 0, 0, test(tables->schema_table));
+                 &tables->grant.privilege, 0, 0, mysql_test(tables->schema_table));
     col_access= get_column_grant(thd, &tables->grant,
                                  db_name->str, table_name->str,
                                  field->field_name) & COL_ACLS;
@@ -4783,13 +4783,13 @@
       table->field[1]->store(option_name, strlen(option_name), scs);
       table->field[2]->store(plugin_decl(plugin)->descr,
                              strlen(plugin_decl(plugin)->descr), scs);
-      tmp= &yesno[test(hton->commit)];
+      tmp= &yesno[mysql_test(hton->commit)];
       table->field[3]->store(tmp->str, tmp->length, scs);
       table->field[3]->set_notnull();
-      tmp= &yesno[test(hton->prepare)];
+      tmp= &yesno[mysql_test(hton->prepare)];
       table->field[4]->store(tmp->str, tmp->length, scs);
       table->field[4]->set_notnull();
-      tmp= &yesno[test(hton->savepoint_set)];
+      tmp= &yesno[mysql_test(hton->savepoint_set)];
       table->field[5]->store(tmp->str, tmp->length, scs);
       table->field[5]->set_notnull();
 
@@ -5365,7 +5365,7 @@
         else
           table->field[14]->store("", 0, cs);
         table->field[14]->set_notnull();
-        DBUG_ASSERT(test(key_info->flags & HA_USES_COMMENT) == 
+        DBUG_ASSERT(mysql_test(key_info->flags & HA_USES_COMMENT) == 
                    (key_info->comment.length > 0));
         if (key_info->flags & HA_USES_COMMENT)
           table->field[15]->store(key_info->comment.str, 
diff -ur a/sql/sql_table.cc b/sql/sql_table.cc
--- a/sql/sql_table.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_table.cc	2013-10-08 15:25:03.000000000 +0100
@@ -3873,7 +3873,7 @@
 	  with length (unlike blobs, where ft code takes data length from a
 	  data prefix, ignoring column->length).
 	*/
-	column->length=test(f_is_blob(sql_field->pack_flag));
+	column->length=mysql_test(f_is_blob(sql_field->pack_flag));
       }
       else
       {
@@ -7047,7 +7047,7 @@
 
       key= new Key(key_type, key_name, strlen(key_name),
                    &key_create_info,
-                   test(key_info->flags & HA_GENERATED_KEY),
+                   mysql_test(key_info->flags & HA_GENERATED_KEY),
                    key_parts);
       new_key_list.push_back(key);
     }
@@ -9069,7 +9069,7 @@
   handlerton **new_engine= &create_info->db_type;
   handlerton *req_engine= *new_engine;
   bool no_substitution=
-        test(thd->variables.sql_mode & MODE_NO_ENGINE_SUBSTITUTION);
+        mysql_test(thd->variables.sql_mode & MODE_NO_ENGINE_SUBSTITUTION);
   if (!(*new_engine= ha_checktype(thd, ha_legacy_type(req_engine),
                                   no_substitution, 1)))
     DBUG_RETURN(true);
diff -ur a/sql/sql_time.cc b/sql/sql_time.cc
--- a/sql/sql_time.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_time.cc	2013-10-08 15:25:03.000000000 +0100
@@ -105,9 +105,9 @@
   uint days;
   ulong daynr=calc_daynr(l_time->year,l_time->month,l_time->day);
   ulong first_daynr=calc_daynr(l_time->year,1,1);
-  bool monday_first= test(week_behaviour & WEEK_MONDAY_FIRST);
-  bool week_year= test(week_behaviour & WEEK_YEAR);
-  bool first_weekday= test(week_behaviour & WEEK_FIRST_WEEKDAY);
+  bool monday_first= mysql_test(week_behaviour & WEEK_MONDAY_FIRST);
+  bool week_year= mysql_test(week_behaviour & WEEK_YEAR);
+  bool first_weekday= mysql_test(week_behaviour & WEEK_FIRST_WEEKDAY);
 
   uint weekday=calc_weekday(first_daynr, !monday_first);
   *year=l_time->year;
diff -ur a/sql/sql_tmp_table.cc b/sql/sql_tmp_table.cc
--- a/sql/sql_tmp_table.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_tmp_table.cc	2013-10-08 15:25:04.000000000 +0100
@@ -484,7 +484,7 @@
   DBUG_PRINT("enter",
              ("distinct: %d  save_sum_fields: %d  rows_limit: %lu  group: %d",
               (int) distinct, (int) save_sum_fields,
-              (ulong) rows_limit,test(group)));
+              (ulong) rows_limit,mysql_test(group)));
 
   thd->inc_status_created_tmp_tables();
 
@@ -1009,7 +1009,7 @@
     table->group=group;				/* Table is grouped by key */
     param->group_buff=group_buff;
     share->keys=1;
-    share->uniques= test(using_unique_constraint);
+    share->uniques= mysql_test(using_unique_constraint);
     table->key_info= share->key_info= keyinfo;
     keyinfo->key_part= key_part_info;
     keyinfo->flags=HA_NOSAME;
@@ -1031,7 +1031,7 @@
       {
 	cur_group->buff=(char*) group_buff;
 	cur_group->field= field->new_key_field(thd->mem_root, table,
-                                               group_buff + test(maybe_null));
+                                               group_buff + mysql_test(maybe_null));
 
 	if (!cur_group->field)
 	  goto err; /* purecov: inspected */
@@ -1079,7 +1079,7 @@
     null_pack_length-=hidden_null_pack_length;
     keyinfo->user_defined_key_parts= 
       ((field_count-param->hidden_field_count) +
-       (share->uniques ? test(null_pack_length) : 0));
+       (share->uniques ? mysql_test(null_pack_length) : 0));
     keyinfo->actual_key_parts= keyinfo->user_defined_key_parts;
     table->distinct= 1;
     share->keys= 1;
@@ -1403,7 +1403,7 @@
   {
     DBUG_PRINT("info",("Creating group key in temporary table"));
     share->keys=1;
-    share->uniques= test(using_unique_constraint);
+    share->uniques= mysql_test(using_unique_constraint);
     table->key_info= table->s->key_info= keyinfo;
     keyinfo->key_part=key_part_info;
     keyinfo->actual_flags= keyinfo->flags= HA_NOSAME;
diff -ur a/sql/sql_union.cc b/sql/sql_union.cc
--- a/sql/sql_union.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_union.cc	2013-10-08 15:25:04.000000000 +0100
@@ -271,7 +271,7 @@
   bool is_union_select;
   DBUG_ENTER("st_select_lex_unit::prepare");
 
-  describe= test(additional_options & SELECT_DESCRIBE);
+  describe= mysql_test(additional_options & SELECT_DESCRIBE);
 
   /*
     result object should be reassigned even if preparing already done for
@@ -462,7 +462,7 @@
     if (global_parameters->ftfunc_list->elements)
       create_options= create_options | TMP_TABLE_FORCE_MYISAM;
 
-    if (union_result->create_result_table(thd, &types, test(union_distinct),
+    if (union_result->create_result_table(thd, &types, mysql_test(union_distinct),
                                           create_options, "", FALSE, TRUE))
       goto err;
     memset(&result_table_list, 0, sizeof(result_table_list));
diff -ur a/sql/sql_update.cc b/sql/sql_update.cc
--- a/sql/sql_update.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sql_update.cc	2013-10-08 15:25:05.000000000 +0100
@@ -222,7 +222,7 @@
                  ha_rows *found_return, ha_rows *updated_return)
 {
   bool		using_limit= limit != HA_POS_ERROR;
-  bool		safe_update= test(thd->variables.option_bits & OPTION_SAFE_UPDATES);
+  bool		safe_update= mysql_test(thd->variables.option_bits & OPTION_SAFE_UPDATES);
   bool          used_key_is_modified= FALSE, transactional_table, will_batch;
   int           res;
   int           error= 1;
diff -ur a/sql/sys_vars.cc b/sql/sys_vars.cc
--- a/sql/sys_vars.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/sys_vars.cc	2013-10-08 15:25:05.000000000 +0100
@@ -2063,7 +2063,7 @@
 {
   SV *sv= (type == OPT_GLOBAL) ? &global_system_variables : &thd->variables;
   sv->engine_condition_pushdown= 
-    test(sv->optimizer_switch & OPTIMIZER_SWITCH_ENGINE_CONDITION_PUSHDOWN);
+    mysql_test(sv->optimizer_switch & OPTIMIZER_SWITCH_ENGINE_CONDITION_PUSHDOWN);
 
   return false;
 }
diff -ur a/sql/table.cc b/sql/table.cc
--- a/sql/table.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/table.cc	2013-10-08 15:25:06.000000000 +0100
@@ -1076,7 +1076,7 @@
   }
   share->db_record_offset= 1;
   /* Set temporarily a good value for db_low_byte_first */
-  share->db_low_byte_first= test(legacy_db_type != DB_TYPE_ISAM);
+  share->db_low_byte_first= mysql_test(legacy_db_type != DB_TYPE_ISAM);
   error=4;
   share->max_rows= uint4korr(head+18);
   share->min_rows= uint4korr(head+22);
@@ -1208,7 +1208,7 @@
                                          keyinfo->comment.length);
       strpos+= 2 + keyinfo->comment.length;
     } 
-    DBUG_ASSERT(test(keyinfo->flags & HA_USES_COMMENT) == 
+    DBUG_ASSERT(mysql_test(keyinfo->flags & HA_USES_COMMENT) == 
                (keyinfo->comment.length > 0));
   }
 
@@ -2388,9 +2388,9 @@
   else if (outparam->file)
   {
     handler::Table_flags flags= outparam->file->ha_table_flags();
-    outparam->no_replicate= ! test(flags & (HA_BINLOG_STMT_CAPABLE
+    outparam->no_replicate= ! mysql_test(flags & (HA_BINLOG_STMT_CAPABLE
                                             | HA_BINLOG_ROW_CAPABLE))
-                            || test(flags & HA_HAS_OWN_BINLOGGING);
+                            || mysql_test(flags & HA_HAS_OWN_BINLOGGING);
   }
   else
   {
@@ -2942,7 +2942,7 @@
     /* header */
     fileinfo[0]=(uchar) 254;
     fileinfo[1]= 1;
-    fileinfo[2]= FRM_VER+3+ test(create_info->varchar);
+    fileinfo[2]= FRM_VER+3+ mysql_test(create_info->varchar);
 
     fileinfo[3]= (uchar) ha_legacy_type(
           ha_checktype(thd,ha_legacy_type(create_info->db_type),0,0));
@@ -2962,7 +2962,7 @@
     */
     for (i= 0; i < keys; i++)
     {
-      DBUG_ASSERT(test(key_info[i].flags & HA_USES_COMMENT) == 
+      DBUG_ASSERT(mysql_test(key_info[i].flags & HA_USES_COMMENT) == 
                  (key_info[i].comment.length > 0));
       if (key_info[i].flags & HA_USES_COMMENT)
         key_comment_total_bytes += 2 + key_info[i].comment.length;
diff -ur a/sql/transaction.cc b/sql/transaction.cc
--- a/sql/transaction.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/transaction.cc	2013-10-08 15:25:07.000000000 +0100
@@ -143,7 +143,7 @@
     thd->server_status&=
       ~(SERVER_STATUS_IN_TRANS | SERVER_STATUS_IN_TRANS_READONLY);
     DBUG_PRINT("info", ("clearing SERVER_STATUS_IN_TRANS"));
-    res= test(ha_commit_trans(thd, TRUE));
+    res= mysql_test(ha_commit_trans(thd, TRUE));
   }
 
   thd->variables.option_bits&= ~OPTION_BEGIN;
@@ -172,7 +172,7 @@
       compatibility.
     */
     const bool user_is_super=
-      test(thd->security_ctx->master_access & SUPER_ACL);
+      mysql_test(thd->security_ctx->master_access & SUPER_ACL);
     if (opt_readonly && !user_is_super)
     {
       my_error(ER_OPTION_PREVENTS_STATEMENT, MYF(0), "--read-only");
@@ -191,7 +191,7 @@
   if (flags & MYSQL_START_TRANS_OPT_WITH_CONS_SNAPSHOT)
     res= ha_start_consistent_snapshot(thd);
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -230,7 +230,7 @@
   thd->transaction.all.reset_unsafe_rollback_flags();
   thd->lex->start_transaction_opt= 0;
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -278,7 +278,7 @@
     thd->server_status&=
       ~(SERVER_STATUS_IN_TRANS | SERVER_STATUS_IN_TRANS_READONLY);
     DBUG_PRINT("info", ("clearing SERVER_STATUS_IN_TRANS"));
-    res= test(ha_commit_trans(thd, TRUE));
+    res= mysql_test(ha_commit_trans(thd, TRUE));
   }
   else if (tc_log)
     tc_log->commit(thd, true);
@@ -334,7 +334,7 @@
   thd->transaction.all.reset_unsafe_rollback_flags();
   thd->lex->start_transaction_opt= 0;
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -397,7 +397,7 @@
 
   thd->transaction.stmt.reset();
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -603,7 +603,7 @@
   if (!res && !binlog_on)
     thd->mdl_context.rollback_to_savepoint(sv->mdl_savepoint);
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -645,7 +645,7 @@
 
   thd->transaction.savepoints= sv->prev;
 
-  DBUG_RETURN(test(res));
+  DBUG_RETURN(mysql_test(res));
 }
 
 
@@ -809,7 +809,7 @@
   else if (xa_state == XA_IDLE && thd->lex->xa_opt == XA_ONE_PHASE)
   {
     int r= ha_commit_trans(thd, TRUE);
-    if ((res= test(r)))
+    if ((res= mysql_test(r)))
       my_error(r == 1 ? ER_XA_RBROLLBACK : ER_XAER_RMERR, MYF(0));
   }
   else if (xa_state == XA_PREPARED && thd->lex->xa_opt == XA_NONE)
@@ -837,9 +837,9 @@
       DEBUG_SYNC(thd, "trans_xa_commit_after_acquire_commit_lock");
 
       if (tc_log)
-        res= test(tc_log->commit(thd, /* all */ true));
+        res= mysql_test(tc_log->commit(thd, /* all */ true));
       else
-        res= test(ha_commit_low(thd, /* all */ true));
+        res= mysql_test(ha_commit_low(thd, /* all */ true));
 
       if (res)
         my_error(ER_XAER_RMERR, MYF(0));
diff -ur a/sql/tztime.cc b/sql/tztime.cc
--- a/sql/tztime.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/tztime.cc	2013-10-08 15:25:07.000000000 +0100
@@ -2643,7 +2643,7 @@
   if (TYPE_SIGNED(time_t))
   {
     t= -100;
-    localtime_negative= test(localtime_r(&t, &tmp) != 0);
+    localtime_negative= mysql_test(localtime_r(&t, &tmp) != 0);
     printf("localtime_r %s negative params \
            (time_t=%d is %d-%d-%d %d:%d:%d)\n",
            (localtime_negative ? "supports" : "doesn't support"), (int)t,
diff -ur a/sql/unireg.cc b/sql/unireg.cc
--- a/sql/unireg.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/sql/unireg.cc	2013-10-08 15:25:08.000000000 +0100
@@ -287,7 +287,7 @@
   maxlength=(uint) next_io_size((ulong) (uint2korr(forminfo_p)+1000));
   int2store(forminfo+2,maxlength);
   int4store(fileinfo+10,(ulong) (filepos+maxlength));
-  fileinfo[26]= (uchar) test((create_info->max_rows == 1) &&
+  fileinfo[26]= (uchar) mysql_test((create_info->max_rows == 1) &&
 			     (create_info->min_rows == 1) && (keys == 0));
   int2store(fileinfo+28,key_info_length);
 
diff -ur a/sql-common/client.c b/sql-common/client.c
--- a/sql-common/client.c	2013-07-10 17:17:27.000000000 +0100
+++ b/sql-common/client.c	2013-10-08 15:12:00.000000000 +0100
@@ -1299,7 +1299,7 @@
           options->secure_auth= TRUE;
           break;
         case OPT_report_data_truncation:
-          options->report_data_truncation= opt_arg ? test(atoi(opt_arg)) : 1;
+          options->report_data_truncation= opt_arg ? mysql_test(atoi(opt_arg)) : 1;
           break;
         case OPT_plugin_dir:
           {
@@ -4344,7 +4344,7 @@
     mysql->options.protocol=MYSQL_PROTOCOL_PIPE; /* Force named pipe */
     break;
   case MYSQL_OPT_LOCAL_INFILE:			/* Allow LOAD DATA LOCAL ?*/
-    if (!arg || test(*(uint*) arg))
+    if (!arg || mysql_test(*(uint*) arg))
       mysql->options.client_flag|= CLIENT_LOCAL_FILES;
     else
       mysql->options.client_flag&= ~CLIENT_LOCAL_FILES;
@@ -4390,7 +4390,7 @@
     mysql->options.secure_auth= *(my_bool *) arg;
     break;
   case MYSQL_REPORT_DATA_TRUNCATION:
-    mysql->options.report_data_truncation= test(*(my_bool *) arg);
+    mysql->options.report_data_truncation= mysql_test(*(my_bool *) arg);
     break;
   case MYSQL_OPT_RECONNECT:
     mysql->reconnect= *(my_bool *) arg;
diff -ur a/storage/federated/ha_federated.cc b/storage/federated/ha_federated.cc
--- a/storage/federated/ha_federated.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/federated/ha_federated.cc	2013-10-08 15:25:08.000000000 +0100
@@ -1462,7 +1462,7 @@
         ptr was incremented by 1. Since store_length still counts null-byte,
         we need to subtract 1 from store_length.
       */
-      ptr+= store_length - test(key_part->null_bit);
+      ptr+= store_length - mysql_test(key_part->null_bit);
       if (tmp.append(STRING_WITH_LEN(" AND ")))
         goto err;
 
@@ -2104,7 +2104,7 @@
     this? Because we only are updating one record, and LIMIT enforces
     this.
   */
-  bool has_a_primary_key= test(table->s->primary_key != MAX_KEY);
+  bool has_a_primary_key= mysql_test(table->s->primary_key != MAX_KEY);
   
   /*
     buffers for following strings
diff -ur a/storage/heap/ha_heap.cc b/storage/heap/ha_heap.cc
--- a/storage/heap/ha_heap.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/heap/ha_heap.cc	2013-10-08 15:25:09.000000000 +0100
@@ -97,7 +97,7 @@
 
 int ha_heap::open(const char *name, int mode, uint test_if_locked)
 {
-  internal_table= test(test_if_locked & HA_OPEN_INTERNAL_TABLE);
+  internal_table= mysql_test(test_if_locked & HA_OPEN_INTERNAL_TABLE);
   if (internal_table || (!(file= heap_open(name, mode)) && my_errno == ENOENT))
   {
     HP_CREATE_INFO create_info;
@@ -113,7 +113,7 @@
     if (rc)
       goto end;
 
-    implicit_emptied= test(created_new_share);
+    implicit_emptied= mysql_test(created_new_share);
     if (internal_table)
       file= heap_open_from_share(internal_share, mode);
     else
diff -ur a/storage/heap/hp_hash.c b/storage/heap/hp_hash.c
--- a/storage/heap/hp_hash.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/heap/hp_hash.c	2013-10-08 15:12:01.000000000 +0100
@@ -596,7 +596,7 @@
   {
     if (seg->null_bit)
     {
-      int found_null=test(rec[seg->null_pos] & seg->null_bit);
+      int found_null=mysql_test(rec[seg->null_pos] & seg->null_bit);
       if (found_null != (int) *key++)
 	return 1;
       if (found_null)
@@ -684,7 +684,7 @@
     uint char_length= seg->length;
     uchar *pos= (uchar*) rec + seg->start;
     if (seg->null_bit)
-      *key++= test(rec[seg->null_pos] & seg->null_bit);
+      *key++= mysql_test(rec[seg->null_pos] & seg->null_bit);
     if (cs->mbmaxlen > 1)
     {
       char_length= my_charpos(cs, pos, pos + seg->length,
@@ -717,7 +717,7 @@
     uint char_length;
     if (seg->null_bit)
     {
-      if (!(*key++= 1 - test(rec[seg->null_pos] & seg->null_bit)))
+      if (!(*key++= 1 - mysql_test(rec[seg->null_pos] & seg->null_bit)))
         continue;
     }
     if (seg->flag & HA_SWAP_KEY)
diff -ur a/storage/myisam/ft_boolean_search.c b/storage/myisam/ft_boolean_search.c
--- a/storage/myisam/ft_boolean_search.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/ft_boolean_search.c	2013-10-08 15:12:01.000000000 +0100
@@ -533,7 +533,7 @@
       {
         if (ftbe->flags & FTB_FLAG_NO ||                     /* 2 */
             ftbe->up->ythresh - ftbe->up->yweaks >
-            (uint) test(ftbe->flags & FTB_FLAG_YES))         /* 1 */
+            (uint) mysql_test(ftbe->flags & FTB_FLAG_YES))         /* 1 */
         {
           FTB_EXPR *top_ftbe=ftbe->up;
           ftbw->docid[0]=HA_OFFSET_ERROR;
diff -ur a/storage/myisam/ha_myisam.cc b/storage/myisam/ha_myisam.cc
--- a/storage/myisam/ha_myisam.cc	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/ha_myisam.cc	2013-10-08 15:25:09.000000000 +0100
@@ -464,8 +464,8 @@
     {
        DBUG_PRINT("error", ("Key %d has different definition", i));
        DBUG_PRINT("error", ("t1_fulltext= %d, t2_fulltext=%d",
-                            test(t1_keyinfo[i].flag & HA_FULLTEXT),
-                            test(t2_keyinfo[i].flag & HA_FULLTEXT)));
+                            mysql_test(t1_keyinfo[i].flag & HA_FULLTEXT),
+                            mysql_test(t2_keyinfo[i].flag & HA_FULLTEXT)));
        DBUG_RETURN(1);
     }
     if (t1_keyinfo[i].flag & HA_SPATIAL && t2_keyinfo[i].flag & HA_SPATIAL)
@@ -475,8 +475,8 @@
     {
        DBUG_PRINT("error", ("Key %d has different definition", i));
        DBUG_PRINT("error", ("t1_spatial= %d, t2_spatial=%d",
-                            test(t1_keyinfo[i].flag & HA_SPATIAL),
-                            test(t2_keyinfo[i].flag & HA_SPATIAL)));
+                            mysql_test(t1_keyinfo[i].flag & HA_SPATIAL),
+                            mysql_test(t2_keyinfo[i].flag & HA_SPATIAL)));
        DBUG_RETURN(1);
     }
     if ((!mysql_40_compat &&
@@ -1067,7 +1067,7 @@
 			share->state.key_map);
     uint testflag=param.testflag;
 #ifdef HAVE_MMAP
-    bool remap= test(share->file_map);
+    bool remap= mysql_test(share->file_map);
     /*
       mi_repair*() functions family use file I/O even if memory
       mapping is available.
@@ -1609,7 +1609,7 @@
   if (h->end_range && h->compare_key_icp(h->end_range) > 0)
     return ICP_OUT_OF_RANGE; /* caller should return HA_ERR_END_OF_FILE already */
 
-  return (ICP_RESULT) test(h->pushed_idx_cond->val_int());
+  return (ICP_RESULT) mysql_test(h->pushed_idx_cond->val_int());
 }
 
 C_MODE_END
diff -ur a/storage/myisam/mi_check.c b/storage/myisam/mi_check.c
--- a/storage/myisam/mi_check.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_check.c	2013-10-08 15:12:01.000000000 +0100
@@ -1159,7 +1159,7 @@
 	  if (param->testflag & (T_EXTEND | T_MEDIUM | T_VERBOSE))
 	  {
 	    if (_mi_rec_check(info,record, info->rec_buff,block_info.rec_len,
-                              test(info->s->calc_checksum)))
+                              mysql_test(info->s->calc_checksum)))
 	    {
 	      mi_check_print_error(param,"Found wrong packed record at %s",
 			  llstr(start_recpos,llbuff));
@@ -2386,7 +2386,7 @@
       if (keyseg[i].flag & HA_SPACE_PACK)
 	sort_param.key_length+=get_pack_length(keyseg[i].length);
       if (keyseg[i].flag & (HA_BLOB_PART | HA_VAR_LENGTH_PART))
-	sort_param.key_length+=2 + test(keyseg[i].length >= 127);
+	sort_param.key_length+=2 + mysql_test(keyseg[i].length >= 127);
       if (keyseg[i].flag & HA_NULL_PART)
 	sort_param.key_length++;
     }
@@ -2877,7 +2877,7 @@
       if (keyseg->flag & HA_SPACE_PACK)
         sort_param[i].key_length+=get_pack_length(keyseg->length);
       if (keyseg->flag & (HA_BLOB_PART | HA_VAR_LENGTH_PART))
-        sort_param[i].key_length+=2 + test(keyseg->length >= 127);
+        sort_param[i].key_length+=2 + mysql_test(keyseg->length >= 127);
       if (keyseg->flag & HA_NULL_PART)
         sort_param[i].key_length++;
     }
@@ -2894,7 +2894,7 @@
   sort_info.total_keys=i;
   sort_param[0].master= 1;
   sort_param[0].fix_datafile= (my_bool)(! rep_quick);
-  sort_param[0].calc_checksum= test(param->testflag & T_CALC_CHECKSUM);
+  sort_param[0].calc_checksum= mysql_test(param->testflag & T_CALC_CHECKSUM);
 
   if (!ftparser_alloc_param(info))
     goto err;
@@ -3564,7 +3564,7 @@
                             sort_param->find_length,
                             (param->testflag & T_QUICK) &&
                             sort_param->calc_checksum &&
-                            test(info->s->calc_checksum)))
+                            mysql_test(info->s->calc_checksum)))
 	  {
 	    mi_check_print_info(param,"Found wrong packed record at %s",
 				llstr(sort_param->start_recpos,llbuff));
@@ -3722,7 +3722,7 @@
 
       do
       {
-	block_length=reclength+ 3 + test(reclength >= (65520-3));
+	block_length=reclength+ 3 + mysql_test(reclength >= (65520-3));
 	if (block_length < share->base.min_block_length)
 	  block_length=share->base.min_block_length;
 	info->update|=HA_STATE_WRITE_AT_END;
@@ -4641,7 +4641,7 @@
   const uchar *end=buf+length;
   for (crc=0; buf != end; buf++)
     crc=((crc << 1) + *((uchar*) buf)) +
-      test(crc & (((ha_checksum) 1) << (8*sizeof(ha_checksum)-1)));
+      mysql_test(crc & (((ha_checksum) 1) << (8*sizeof(ha_checksum)-1)));
   return crc;
 }
 
diff -ur a/storage/myisam/mi_create.c b/storage/myisam/mi_create.c
--- a/storage/myisam/mi_create.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_create.c	2013-10-08 15:12:01.000000000 +0100
@@ -134,7 +134,7 @@
 	pack_reclength++;
         min_pack_length++;
         /* We must test for 257 as length includes pack-length */
-        if (test(rec->length >= 257))
+        if (mysql_test(rec->length >= 257))
 	{
 	  long_varchar_count++;
 	  pack_reclength+= 2;			/* May be packed on 3 bytes */
@@ -193,7 +193,7 @@
   packed=(packed+7)/8;
   if (pack_reclength != INT_MAX32)
     pack_reclength+= reclength+packed +
-      test(test_all_bits(options, HA_OPTION_CHECKSUM | HA_OPTION_PACK_RECORD));
+      mysql_test(test_all_bits(options, HA_OPTION_CHECKSUM | HA_OPTION_PACK_RECORD));
   min_pack_length+=packed;
 
   if (!ci->data_file_length && ci->max_rows)
@@ -544,7 +544,7 @@
   share.base.records=ci->max_rows;
   share.base.reloc=  ci->reloc_rows;
   share.base.reclength=real_reclength;
-  share.base.pack_reclength=reclength+ test(options & HA_OPTION_CHECKSUM);
+  share.base.pack_reclength=reclength+ mysql_test(options & HA_OPTION_CHECKSUM);
   share.base.max_pack_length=pack_reclength;
   share.base.min_pack_length=min_pack_length;
   share.base.pack_bits=packed;
diff -ur a/storage/myisam/mi_delete.c b/storage/myisam/mi_delete.c
--- a/storage/myisam/mi_delete.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_delete.c	2013-10-08 15:12:02.000000000 +0100
@@ -352,7 +352,7 @@
 	DBUG_RETURN(-1);
       }
       /* Page will be update later if we return 1 */
-      DBUG_RETURN(test(length <= (info->quick_mode ? MI_MIN_KEYBLOCK_LENGTH :
+      DBUG_RETURN(mysql_test(length <= (info->quick_mode ? MI_MIN_KEYBLOCK_LENGTH :
 				  (uint) keyinfo->underflow_block_length)));
     }
     save_flag=1;
diff -ur a/storage/myisam/mi_dynrec.c b/storage/myisam/mi_dynrec.c
--- a/storage/myisam/mi_dynrec.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_dynrec.c	2013-10-08 15:12:02.000000000 +0100
@@ -414,7 +414,7 @@
   {
     /* No deleted blocks;  Allocate a new block */
     *filepos=info->state->data_file_length;
-    if ((tmp=reclength+3 + test(reclength >= (65520-3))) <
+    if ((tmp=reclength+3 + mysql_test(reclength >= (65520-3))) <
 	info->s->base.min_block_length)
       tmp= info->s->base.min_block_length;
     else
@@ -862,7 +862,7 @@
       if (length < reclength)
       {
 	uint tmp=MY_ALIGN(reclength - length + 3 +
-			  test(reclength >= 65520L),MI_DYN_ALIGN_SIZE);
+			  mysql_test(reclength >= 65520L),MI_DYN_ALIGN_SIZE);
 	/* Don't create a block bigger than MI_MAX_BLOCK_LENGTH */
 	tmp= MY_MIN(length+tmp, MI_MAX_BLOCK_LENGTH)-length;
 	/* Check if we can extend this block */
@@ -1023,7 +1023,7 @@
 	    pos++;
 	}
 	new_length=(uint) (end-pos);
-	if (new_length +1 + test(rec->length > 255 && new_length > 127)
+	if (new_length +1 + mysql_test(rec->length > 255 && new_length > 127)
 	    < length)
 	{
 	  if (rec->length > 255 && new_length > 127)
@@ -1143,7 +1143,7 @@
 	    pos++;
 	}
 	new_length=(uint) (end-pos);
-	if (new_length +1 + test(rec->length > 255 && new_length > 127)
+	if (new_length +1 + mysql_test(rec->length > 255 && new_length > 127)
 	    < length)
 	{
 	  if (!(flag & bit))
@@ -1195,7 +1195,7 @@
     else
       to+= length;
   }
-  if (packed_length != (uint) (to - rec_buff) + test(info->s->calc_checksum) ||
+  if (packed_length != (uint) (to - rec_buff) + mysql_test(info->s->calc_checksum) ||
       (bit != 1 && (flag & ~(bit - 1))))
     goto err;
   if (with_checksum && ((uchar) info->checksum != (uchar) *to))
diff -ur a/storage/myisam/mi_extra.c b/storage/myisam/mi_extra.c
--- a/storage/myisam/mi_extra.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_extra.c	2013-10-08 15:12:02.000000000 +0100
@@ -55,7 +55,7 @@
     {
       reinit_io_cache(&info->rec_cache,READ_CACHE,0,
 		      (pbool) (info->lock_type != F_UNLCK),
-		      (pbool) test(info->update & HA_STATE_ROW_CHANGED)
+		      (pbool) mysql_test(info->update & HA_STATE_ROW_CHANGED)
 		      );
     }
     info->update= ((info->update & HA_STATE_CHANGED) | HA_STATE_NEXT_FOUND |
@@ -116,7 +116,7 @@
     {
       reinit_io_cache(&info->rec_cache,READ_CACHE,info->nextpos,
 		      (pbool) (info->lock_type != F_UNLCK),
-		      (pbool) test(info->update & HA_STATE_ROW_CHANGED));
+		      (pbool) mysql_test(info->update & HA_STATE_ROW_CHANGED));
       info->update&= ~HA_STATE_ROW_CHANGED;
       if (share->concurrent_insert)
 	info->rec_cache.end_of_file=info->state->data_file_length;
diff -ur a/storage/myisam/mi_locking.c b/storage/myisam/mi_locking.c
--- a/storage/myisam/mi_locking.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_locking.c	2013-10-08 15:12:02.000000000 +0100
@@ -567,5 +567,5 @@
     if (!lock_error)
       lock_error=mi_lock_database(info,old_lock);
   }
-  return test(lock_error || write_error);
+  return mysql_test(lock_error || write_error);
 }
diff -ur a/storage/myisam/mi_open.c b/storage/myisam/mi_open.c
--- a/storage/myisam/mi_open.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_open.c	2013-10-08 15:12:03.000000000 +0100
@@ -510,7 +510,7 @@
       info.s=share;
       if (_mi_read_pack_info(&info,
 			     (pbool)
-			     test(!(share->options &
+			     mysql_test(!(share->options &
 				    (HA_OPTION_PACK_RECORD |
 				     HA_OPTION_TEMP_COMPRESS_RECORD)))))
 	goto err;
diff -ur a/storage/myisam/mi_search.c b/storage/myisam/mi_search.c
--- a/storage/myisam/mi_search.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_search.c	2013-10-08 15:12:03.000000000 +0100
@@ -82,7 +82,7 @@
   }
 
   if (!(buff=_mi_fetch_keypage(info,keyinfo,pos,DFLT_INIT_HITS,info->buff,
-                               test(!(nextflag & SEARCH_SAVE_BUFF)))))
+                               mysql_test(!(nextflag & SEARCH_SAVE_BUFF)))))
     goto err;
   DBUG_DUMP("page", buff, mi_getint(buff));
 
@@ -125,7 +125,7 @@
   {
     uchar *old_buff=buff;
     if (!(buff=_mi_fetch_keypage(info,keyinfo,pos,DFLT_INIT_HITS,info->buff,
-                                 test(!(nextflag & SEARCH_SAVE_BUFF)))))
+                                 mysql_test(!(nextflag & SEARCH_SAVE_BUFF)))))
       goto err;
     keypos=buff+(keypos-old_buff);
     maxpos=buff+(maxpos-old_buff);
diff -ur a/storage/myisam/mi_test1.c b/storage/myisam/mi_test1.c
--- a/storage/myisam/mi_test1.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/mi_test1.c	2013-10-08 15:12:03.000000000 +0100
@@ -265,14 +265,14 @@
 	if (verbose || (flags[j] >= 1 ||
 			(error && my_errno != HA_ERR_KEY_NOT_FOUND)))
 	  printf("key: '%.*s'  mi_rkey:  %3d  errno: %3d\n",
-		 (int) key_length,key+test(null_fields),error,my_errno);
+		 (int) key_length,key+mysql_test(null_fields),error,my_errno);
       }
       else
       {
 	error=mi_delete(file,read_record);
 	if (verbose || error)
 	  printf("key: '%.*s'  mi_delete: %3d  errno: %3d\n",
-		 (int) key_length, key+test(null_fields), error, my_errno);
+		 (int) key_length, key+mysql_test(null_fields), error, my_errno);
 	if (! error)
 	{
 	  deleted++;
@@ -293,7 +293,7 @@
 	(error && (flags[i] != 0 || my_errno != HA_ERR_KEY_NOT_FOUND)))
     {
       printf("key: '%.*s'  mi_rkey: %3d  errno: %3d  record: %s\n",
-	     (int) key_length,key+test(null_fields),error,my_errno,record+1);
+	     (int) key_length,key+mysql_test(null_fields),error,my_errno,record+1);
     }
   }
 
diff -ur a/storage/myisam/myisamchk.c b/storage/myisam/myisamchk.c
--- a/storage/myisam/myisamchk.c	2013-07-10 17:17:27.000000000 +0100
+++ b/storage/myisam/myisamchk.c	2013-10-08 15:12:03.000000000 +0100
@@ -1118,7 +1118,7 @@
   if ((param->testflag & T_AUTO_INC) ||
       ((param->testflag & T_REP_ANY) && info->s->base.auto_key))
     update_auto_increment_key(param, info,
-			      (my_bool) !test(param->testflag & T_AUTO_INC));
+			      (my_bool) !mysql_test(param->testflag & T_AUTO_INC));
 
   if (!(param->testflag & T_DESCRIPT))
   {
diff -ur a/strings/decimal.c b/strings/decimal.c
--- a/strings/decimal.c	2013-07-10 17:17:26.000000000 +0100
+++ b/strings/decimal.c	2013-10-08 15:12:03.000000000 +0100
@@ -353,7 +353,7 @@
   if (!(intg_len= fixed_precision ? fixed_intg : intg))
     intg_len= 1;
   frac_len= fixed_precision ? fixed_decimals : frac;
-  len= from->sign + intg_len + test(frac) + frac_len;
+  len= from->sign + intg_len + mysql_test(frac) + frac_len;
   if (fixed_precision)
   {
     if (frac > fixed_decimals)
@@ -387,7 +387,7 @@
     else
       frac-=j;
     frac_len= frac;
-    len= from->sign + intg_len + test(frac) + frac_len;
+    len= from->sign + intg_len + mysql_test(frac) + frac_len;
   }
   *to_len= len;
   s[len]= 0;
diff -ur a/vio/vio.c b/vio/vio.c
--- a/vio/vio.c	2013-07-10 17:17:27.000000000 +0100
+++ b/vio/vio.c	2013-10-08 15:12:03.000000000 +0100
@@ -202,7 +202,7 @@
   if (old_vio.write_timeout >= 0)
     ret|= vio_timeout(vio, 1, old_vio.write_timeout);
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
diff -ur a/vio/viosocket.c b/vio/viosocket.c
--- a/vio/viosocket.c	2013-07-10 17:17:27.000000000 +0100
+++ b/vio/viosocket.c	2013-10-08 15:12:04.000000000 +0100
@@ -854,16 +854,16 @@
   switch (event)
   {
   case VIO_IO_EVENT_READ:
-    ret= test(FD_ISSET(fd, &readfds));
+    ret= mysql_test(FD_ISSET(fd, &readfds));
     break;
   case VIO_IO_EVENT_WRITE:
   case VIO_IO_EVENT_CONNECT:
-    ret= test(FD_ISSET(fd, &writefds));
+    ret= mysql_test(FD_ISSET(fd, &writefds));
     break;
   }
 
   /* Error conditions pending? */
-  ret|= test(FD_ISSET(fd, &exceptfds));
+  ret|= mysql_test(FD_ISSET(fd, &exceptfds));
 
   /* Not a timeout, ensure that a condition was met. */
   DBUG_ASSERT(ret);
@@ -946,7 +946,7 @@
 #else
       errno= error;
 #endif
-      ret= test(error);
+      ret= mysql_test(error);
     }
   }
 
@@ -957,7 +957,7 @@
       DBUG_RETURN(TRUE);
   }
 
-  DBUG_RETURN(test(ret));
+  DBUG_RETURN(mysql_test(ret));
 }
 
 
