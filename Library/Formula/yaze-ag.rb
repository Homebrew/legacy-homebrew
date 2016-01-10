class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.30.1.tar.gz"
  sha256 "bd1cbb447365bacdc5a890f7eb1f57cf67a5a48652244f65449557b453b6d446"

  # Fix missing sys header include for caddr_t on Mac OS
  # Fix omission of creating bin directory by custom Makefile
  # Upstream author is aware of this issue:
  # https://github.com/Homebrew/homebrew/pull/16817
  patch :DATA

  def install
    system "make", "-f", "Makefile_solaris_gcc",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    system "#{bin}/yaze", "'sys quit'"
  end
end

__END__
diff --git a/Makefile_solaris_gcc b/Makefile_solaris_gcc
index 9e469a3..b25d007 100644
--- a/Makefile_solaris_gcc
+++ b/Makefile_solaris_gcc
@@ -140,11 +140,14 @@ simz80.c:	simz80.pl
		perl -w simz80.pl >simz80.c
		chmod a-w simz80.c

+cdm.o:		CFLAGS+=-include sys/types.h
+
 cdm:		cdm.o
		$(CC) $(CFLAGS) cdm.o $(LIBS) -o $@

 install:	all
		rm -rf $(LIBDIR)
+		mkdir -p $(BINDIR)
		mkdir -p $(LIBDIR)
		mkdir -p $(MANDIR)
		$(INSTALL) -s -c -m 755 yaze_bin $(BINDIR)
