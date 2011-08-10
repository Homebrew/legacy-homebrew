require 'formula'

class Pioneers < Formula
  url 'https://downloads.sourceforge.net/project/pio/Source/pioneers-0.12.3.1.tar.gz'
  homepage 'http://pio.sourceforge.net/'
  md5 'd0cb6189a6fc6f25641b4f2465aa2eb2'

  depends_on 'intltool' # for NLS
  depends_on 'gettext'
  depends_on 'gtk+'

  # def patches
  #   DATA
  # end

  def install
    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

# fix usage of echo options not supported by sh
__END__
diff --git a/Makefile.in b/Makefile.in
index a55dab0..32975e3 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -4012,23 +4012,23 @@ uninstall-man: uninstall-man6
 
 common/authors.h: AUTHORS
 	@mkdir_p@ common
-	echo -n "#define AUTHORLIST " > $@
+	/bin/echo -n "#define AUTHORLIST " > $@
 	sed -e's/ <.*//; s/$$/", \\/; s/^/"/; /^"[[:space:]]*", \\$$/d' $< >> $@
-	echo "NULL" >> $@
+	/bin/echo "NULL" >> $@
 
 # This target is not called common/version.h (although it builds that file),
 # because it must be PHONY, but should only be rebuilt once.
 build_version:
 	@mkdir_p@ common
-	echo -n '#define FULL_VERSION "$(VERSION)' >> common/version.new
+	/bin/echo -n '#define FULL_VERSION "$(VERSION)' >> common/version.new
 	if svn info > /dev/null 2>&1; then				\
-		echo -n ".r`svn info | grep Revision | cut -f2 -d\ `"	\
+		/bin/echo -n ".r`svn info | grep Revision | cut -f2 -d\ `"	\
 			>> common/version.new				;\
 		if svn status | grep -vq ^\? ; then			\
-			echo -n '.M' >> common/version.new		;\
+			/bin/echo -n '.M' >> common/version.new		;\
 		fi							;\
 	fi
-	echo '"' >> common/version.new
+	/bin/echo '"' >> common/version.new
 	if diff common/version.h common/version.new > /dev/null 2>&1; then \
 		rm common/version.new					;\
 	else								\
