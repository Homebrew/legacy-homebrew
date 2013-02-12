require 'formula'

class PhoronixTestSuite < Formula
  homepage 'http://www.phoronix-test-suite.com/'
  url 'http://www.phoronix-test-suite.com/download.php?file=phoronix-test-suite-4.2.0'
  sha1 'f2a42a3516cd1c0efa0aa117c80f942ffb5a0456'

  def patches; DATA; end

  def install
    system "./install-sh", prefix
  end
end


__END__
--- a/install-sh	2012-01-04 08:43:26.000000000 -0800
+++ b/install-sh	2012-04-23 20:34:21.000000000 -0700
@@ -55,11 +55,11 @@
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/man/man1/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-mkdir -p $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/
+mkdir -p $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/
 
-cp CHANGE-LOG $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-cp COPYING $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-cp AUTHORS $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
+cp CHANGE-LOG $DESTDIR$INSTALL_PREFIX/CHANGELOG
+cp COPYING $DESTDIR$INSTALL_PREFIX/
+cp AUTHORS $DESTDIR$INSTALL_PREFIX/
 
 cd documentation/
 cp -r * $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
@@ -67,13 +67,13 @@
 rm -rf $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/man-pages/
 
 cp documentation/man-pages/*.1 $DESTDIR$INSTALL_PREFIX/share/man/man1/
-cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/phoronix-test-suite
+cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/phoronix-test-suite.bash
 cp pts-core/static/images/phoronix-test-suite.png $DESTDIR$INSTALL_PREFIX/share/icons/hicolor/48x48/apps/phoronix-test-suite.png
 cp pts-core/static/phoronix-test-suite.desktop $DESTDIR$INSTALL_PREFIX/share/applications/
 cp pts-core/static/phoronix-test-suite-launcher.desktop $DESTDIR$INSTALL_PREFIX/share/applications/
 
 rm -f $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts/etc/scripts/package-build-*
-cp -r pts-core/ $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
+cp -r pts-core $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite
 rm -f $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/static/phoronix-test-suite.desktop
 rm -f $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/static/phoronix-test-suite-launcher.desktop
 rm -f $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/openbenchmarking.org/openbenchmarking-mime.xml
@@ -88,7 +88,7 @@
 # sed 's:\$url = PTS_PATH . \"documentation\/index.html\";:\$url = \"'"$INSTALL_PREFIX"'\/share\/doc\/packages\/phoronix-test-suite\/index.html\";:g' pts-core/commands/gui_gtk.php > $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/commands/gui_gtk.php
 
 # XDG MIME OpenBenchmarking support
-if [ "X$DESTDIR" = "X" ]
+if [ "X$INSTALL_PREFIX" = "X" ]
 then
 	#No chroot
 	xdg-mime install pts-core/openbenchmarking.org/openbenchmarking-mime.xml
@@ -102,7 +102,7 @@
 
 fi
 
-echo -e "\nPhoronix Test Suite Installation Completed\n
+echo "\nPhoronix Test Suite Installation Completed\n
 Executable File: $INSTALL_PREFIX/bin/phoronix-test-suite
 Documentation: $INSTALL_PREFIX/share/doc/phoronix-test-suite/
 Phoronix Test Suite Files: $INSTALL_PREFIX/share/phoronix-test-suite/\n"
