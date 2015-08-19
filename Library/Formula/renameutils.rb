class Renameutils < Formula
  desc "Tools for file renaming"
  homepage "http://www.nongnu.org/renameutils/"
  url "http://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz"
  sha256 "cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3"

  bottle do
    cellar :any
    sha1 "f2ad6649f1636f36308781ca75d80757ddf03d5c" => :yosemite
    sha1 "7e9d5223ce53c47d32dacbfb841c44b6f4e0361f" => :mavericks
    sha1 "00fe259bce0743080676d617e9a521d7d4732418" => :mountain_lion
  end

  depends_on "readline" # Use instead of system libedit
  depends_on "coreutils"

  # Use the GNU versions of certain system utilities. See:
  # https://trac.macports.org/ticket/24525
  # Patches rewritten at version 0.12.0 to handle file changes.
  # The fourth patch is new and fixes a Makefile syntax error that causes
  # make install to fail.  Reported upstream via email and fixed in HEAD.
  # Remove patch #4 at version > 0.12.0.  The first three should persist.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write ("Hello World!")
    pipe_output("#{bin}/icp test.txt", ".2\n")
    assert_equal File.read("test.txt"), File.read("test.txt.2")
  end
end

__END__
--- a/src/apply.c
+++ b/src/apply.c
@@ -72,9 +72,9 @@ perform_command(FileSpec *spec)
     if (force_command != NULL)
         command = force_command;
     else if (strcmp(program, "qmv") == 0)
-        command = "mv";
+        command = "gmv";
     else
-        command = "cp";
+        command = "gcp";
 
     child = fork();
     if (child < 0) {
--- a/src/icmd.c
+++ b/src/icmd.c
@@ -45,8 +45,8 @@
 #include "common/string-utils.h"
 #include "common/common.h"
 
-#define MV_COMMAND "mv"
-#define CP_COMMAND "cp"
+#define MV_COMMAND "gmv"
+#define CP_COMMAND "gcp"
 /* This list should be up to date with mv and cp!
  * It was last updated on 2007-11-30 for
  * Debian coreutils 5.97-5.4 in unstable.
--- a/src/qcmd.c	2011-08-21 10:15:51.000000000 -0700
+++ b/src/qcmd.c	2012-06-28 15:51:48.000000000 -0700
@@ -239,7 +239,7 @@
     editor_program = xstrdup(editor_program);
 
     if (ls_program == NULL)
-        ls_program = xstrdup("ls");
+        ls_program = xstrdup("gls");
 
     /* Parse format options */
     if (format_options != NULL && !format->parse_options(format_options))
--- a/src/Makefile.in	2012-04-23 04:24:10.000000000 -0700
+++ b/src/Makefile.in	2012-06-29 00:42:45.000000000 -0700
@@ -1577,7 +1577,7 @@
 	@[ -f icp ] || (echo $(LN_S) icmd icp ; $(LN_S) icmd icp)
 
 install-exec-local:
-	$(mkdir_p) $(DESTDIR)($bindir)
+	$(mkdir_p) $(DESTDIR)$(bindir)
 	@[ -f $(DESTDIR)$(bindir)/qmv ] || (echo $(LN_S) qcmd $(DESTDIR)$(bindir)/qmv ; $(LN_S) qcmd $(DESTDIR)$(bindir)/qmv)
 	@[ -f $(DESTDIR)$(bindir)/qcp ] || (echo $(LN_S) qcmd $(DESTDIR)$(bindir)/qcp ; $(LN_S) qcmd $(DESTDIR)$(bindir)/qcp)
 	@[ -f $(DESTDIR)$(bindir)/imv ] || (echo $(LN_S) icmd $(DESTDIR)$(bindir)/imv ; $(LN_S) icmd $(DESTDIR)$(bindir)/imv)
