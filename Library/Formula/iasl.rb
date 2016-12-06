require 'formula'

class Iasl < Formula
  homepage 'https://www.acpica.org'
  url 'https://www.acpica.org/download/acpica-unix-20130214.tar.gz'
  sha1 '5e4c0e1c4ed8f00f980e073f826b2d8fe5d92c15'

  def patches
    DATA
  end

  def install
    ENV.j1

    bin.mkpath

    system "make iasl HOST=_LINUX"
    system "make install PROGS=iasl INSTALLDIR=#{bin}"
  end

  def test
    system "#{bin}/iasl -h"
  end
end

__END__
# BSD cp doesn't understand --remove-destination so use --force instead
diff --git a/generate/unix/Makefile.config b/generate/unix/Makefile.config
index 65242e0..14e49c4 100644
--- a/generate/unix/Makefile.config
+++ b/generate/unix/Makefile.config
@@ -61,7 +61,7 @@ RENAMEPROG = \
 #
 COPYPROG = \
 	@mkdir -p ../$(BINDIR); \
-	cp --remove-destination $(PROG) ../$(BINDIR); \
+	cp -f $(PROG) ../$(BINDIR); \
 	echo "Copied $(PROG) to $(FINAL_PROG)";

 #

# BSD install recursive directory creating won't let you copy the file also, 
# unlike GNU's. Just have install install the correct binary and rely on
# bin.mkpath to create the destdir beforehand
diff --git a/generate/unix/Makefile.config b/generate/unix/Makefile.config
index 14e49c4..62eb4eb 100644
--- a/generate/unix/Makefile.config
+++ b/generate/unix/Makefile.config
@@ -45,7 +45,7 @@ BITSFLAG =   -m$(BITS)
 COMPILEOBJ = $(CC) -c $(CFLAGS) $(OPT_CFLAGS) -o $@ $<
 LINKPROG =   $(CC) $(OBJECTS) -o $(PROG) $(LDFLAGS)
 INSTALLDIR = /usr/bin
-INSTALLPROG = install -D ../$(BINDIR)/$(PROG) $(DESTDIR)$(INSTALLDIR)/$(PROG)
+INSTALLPROG = install ../$(BINDIR)/$(PROG) $(DESTDIR)$(INSTALLDIR)/$(PROG)
 
 #
 # Rename a .exe file if necessary

