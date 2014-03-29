require "formula"

class Phlawd < Formula

  homepage "https://github.com/chinchliff/phlawd/releases/tag/3.4a"
  url "https://github.com/chinchliff/phlawd/releases/download/3.4a/phlawd_3.4a_source.tar.gz"
  sha1 "342cf5441e23e27984bf9e294c710b4a438d9fef"

  fails_with :clang do
    build 503
    cause <<-eos
      PHLAWD requires openmp support, which is not available in clang.
      Currently, PHLAWD can only be compiled with gcc > 4.2.
    eos
  end

  fails_with :llvm do
    build 0
    cause "Does not properly build with llvm."
  end

  # correct the makefile to look for dependencies where brew installs them
  patch :DATA

  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "sqlitewrapped"

  def install
    system "make", "-f", "Makefile.MAC"
    system "mv", "PHLAWD", "#{prefix}/"
    install_target="/usr/local/bin/phlawd"
    if File.file?(install_target)
      system "mv", install_target, install_target + "_previous"
    end
    system "ln", "-s", "#{prefix}/PHLAWD", install_target
  end

  test do
    system "PHLAWD"
  end
end

__END__
diff --git a/Makefile.MAC b/Makefile.MAC
index a48def0..4b683dd 100644
--- a/Makefile.MAC
+++ b/Makefile.MAC
@@ -91,8 +91,7 @@ all: PHLAWD
 # Tool invocations
 PHLAWD: $(OBJS) $(USER_OBJS)
 	@echo 'Building target: $@'
-#	$(CC) $(CFLAGS) -L../deps/mac -L/usr/local/lib -L/usr/lib -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
-	$(CC) $(CFLAGS) -L../deps/mac -L/usr/local/lib -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
+	$(CC) $(CFLAGS) -L/usr/local/lib -I/usr/local/include -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
 	@echo 'Finished building target: $@'
 	@echo ' '
 
