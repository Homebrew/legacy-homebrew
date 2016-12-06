require 'formula'

class Slib <Formula
  url 'http://groups.csail.mit.edu/mac/ftpdir/scm/slib-3b3.zip'
  homepage 'http://people.csail.mit.edu/jaffer/SLIB'
  md5 'f761f5fce66b835e557d713626c6a920'

  def patches
    DATA
  end

  def install
    system "make install prefix=#{prefix}/ INSTALL_INFO=install-info"
  end

  def test
    system "slib --version"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 2f11a10..780616b 100644
--- a/Makefile
+++ b/Makefile
@@ -301,15 +301,13 @@ w32install: slib.nsi slib.html
 
 ver = $(VERSION)
 
-collect.sc:
+collectx.scm: collect.scm macwork.scm
 	echo "(require 'macros-that-work)" > collect.sc
 	echo "(require 'pprint-file)" >> collect.sc
 	echo "(require 'yasos)" >> collect.sc
 	echo "(pprint-filter-file \"collect.scm\" macwork:expand \"collectx.scm\")" >> collect.sc
 	echo "(slib:exit #t)" >> collect.sc
-
-collectx.scm: collect.sc collect.scm macwork.scm
-	$(SCHEME) < $<
+	$(SCHEME) < collect.sc
 
 temp/slib/: $(allfiles)
 	-rm -rf temp
