require 'formula'

class Sloccount <Formula
  @url='http://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz'
  @homepage='http://www.dwheeler.com/sloccount/'
  @md5='09abd6e2a016ebaf7552068a1dba1249'

  def patches
      # We create the install dir or install falls over
      # We delete makefile.orig or patch falls over
      DATA
  end

  def install
    FileUtils.rm("makefile.orig")
    system "make", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/makefile b/makefile
index 0c029f1..8e303e2 100644
--- a/makefile
+++ b/makefile
@@ -164,6 +164,7 @@ c_lines: C_LINES.C
 
 
 install_programs: all
+	$(INSTALL_A_DIR) $(INSTALL_DIR)
 	$(INSTALL) $(EXECUTABLES) $(INSTALL_DIR)
 
 uninstall_programs:

diff --git a/break_filelist b/break_filelist
index ad2de47..ff854e0 100755
--- a/break_filelist
+++ b/break_filelist
@@ -205,6 +205,7 @@ $noisy = 0;            # Set to 1 if you want noisy reports.
   "hs" => "haskell", "lhs" => "haskell",
    # ???: .pco is Oracle Cobol
   "jsp" => "jsp",  # Java server pages
+  "erl" => "erlang",
 );


diff --git a/erlang_count b/erlang_count
new file mode 100755
index 0000000..50af97c
--- /dev/null
+++ b/erlang_count
@@ -0,0 +1,3 @@
+#!/bin/sh
+
+generic_count '%' $@
diff --git a/makefile b/makefile
index 0c029f1..7b446d5 100644
--- a/makefile
+++ b/makefile
@@ -95,6 +95,7 @@ EXECUTABLES= \
    count_extensions \
    count_unknown_ext \
    csh_count \
+   erlang_count \
    exp_count \
    fortran_count \
    f90_count \
