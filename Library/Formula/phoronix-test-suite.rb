require 'formula'

class PhoronixTestSuite <Formula
  homepage 'http://www.phoronix-test-suite.com/'
  url "http://www.phoronix-test-suite.com/download.php?file=phoronix-test-suite-2.8.1"
  md5 "623d0ea01963df438f738ec50e90afc6"

  def patches; DATA; end

  def install
    system "./install-sh #{prefix}"
  end
end


__END__
diff --git a/install-sh b/install-sh
index 596dfae..c83ebe2 100755
--- a/install-sh
+++ b/install-sh
@@ -53,7 +53,7 @@ mkdir -p $DESTDIR$INSTALL_PREFIX/share/icons/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/man/man1/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-mkdir -p $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/
+mkdir -p $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/
 
 cp CHANGE-LOG $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
 cp COPYING $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
@@ -69,9 +69,9 @@ cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/../etc/bash_completio
 cp pts-core/static/images/phoronix-test-suite.png $DESTDIR$INSTALL_PREFIX/share/icons/phoronix-test-suite.png
 cp pts-core/static/phoronix-test-suite.desktop $DESTDIR$INSTALL_PREFIX/share/applications/
 
-cp -r pts/ $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
+cp -r pts $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite
 rm -f $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts/etc/scripts/package-build-*
-cp -r pts-core/ $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
+cp -r pts-core $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite
 
 sed 's:PTS_DIR=`pwd`:PTS_DIR='"$INSTALL_PREFIX"'\/share\/phoronix-test-suite:g' phoronix-test-suite > $DESTDIR$INSTALL_PREFIX/bin/phoronix-test-suite
 chmod +x $DESTDIR$INSTALL_PREFIX/bin/phoronix-test-suite
