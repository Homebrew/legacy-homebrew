require 'brewkit'

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
