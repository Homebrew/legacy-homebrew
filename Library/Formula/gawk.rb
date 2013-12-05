require 'formula'

class Gawk < Formula
  homepage 'http://www.gnu.org/software/gawk/'
  url 'http://ftpmirror.gnu.org/gawk/gawk-4.1.0.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/gawk/gawk-4.1.0.tar.xz'
  sha1 'caabca3c1a59d05807c826c45a4639b82cad612a'

  depends_on 'xz' => :build

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-readline",
                          "--without-mpfr",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make check"
    system "make install"

    (libexec/'gnubin').install_symlink bin/"gawk" => "awk"
    (libexec/'gnuman/man1').install_symlink man1/"gawk.1" => "awk.1"
  end

  def caveats; <<-EOS.undent
    The command has been installed with the prefix 'g'.

    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_prefix}/libexec/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_prefix}/libexec/gnuman:$MANPATH"

    EOS
  end

  def patches
    # Prevent the installer from linking awk to gawk
    DATA
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index e3fcf2d..44bebae 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -1131,9 +1131,7 @@ uninstall-am: uninstall-binPROGRAMS uninstall-includeHEADERS
 install-exec-hook:
 	(cd $(DESTDIR)$(bindir); \
 	$(LN) gawk$(EXEEXT) gawk-$(VERSION)$(EXEEXT) 2>/dev/null ; \
-	if [ ! -f awk ]; \
-	then	$(LN_S) gawk$(EXEEXT) awk; \
-	fi; exit 0)
+	exit 0)
 
 # Undo the above when uninstalling
 uninstall-links:
