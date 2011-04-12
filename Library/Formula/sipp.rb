require 'formula'

class Sipp < Formula
  url 'http://downloads.sourceforge.net/project/sipp/sipp/3.2/sipp.svn.tar.gz'
  homepage 'http://sipp.sourceforge.net/'
  md5 '2a3a60cb4317dcf8eb5482f6a955e4d0'
  version '3.2'

  def install
    system "make DESTDIR=#{prefix} install"
  end

  def patches
    # add 'install' rule
    DATA
  end
end

__END__
diff --git a/Makefile b/Makefile
index 23a3fac..0378308 100644
--- a/Makefile
+++ b/Makefile
@@ -232,3 +232,7 @@ archive:
 fortune.so: fortune.cpp
 	g++ -fPIC $(CPPFLAGS) $(MFLAGS) $(DEBUG_FLAGS) $(_HPUX_LI_FLAG) $(INCDIR) -c -o fortune.o $<
 	gcc -shared -Wl,-soname,fortune.so -o $@ fortune.o
+
+install: all
+	install -d -m 755 $(DESTDIR)/bin
+	install -m 755 sipp $(DESTDIR)/bin
