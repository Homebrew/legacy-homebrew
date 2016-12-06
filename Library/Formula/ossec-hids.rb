require 'formula'

class OssecHids < Formula
  homepage 'http://www.ossec.net'
  url 'http://www.ossec.net/files/ossec-hids-2.7.tar.gz'
  sha1 '721aa7649d5c1e37007b95a89e685af41a39da43'
  keg_only "OSSEC wants to live in /var/osssec and copies itself there"
  # must be built with recent gcc, the patch below sets it up 
  depends_on 'homebrew/dupes/gcc' => [:build, 'enable-cxx']
  env :std

  def install
    # using the interactive install script as recommended by ossec
    # also, there are to many install options for command line switches
    # therefore the script is called with safe_system to allow interaction 
    safe_system "sudo ./install.sh"
    system "sudo rm -r bin src" # generated scripts with root only perms removed manually
  end

  fails_with :clang do
    build 425
    cause <<-EOS.undent
        Ossec will not build it's included os_crypto on clang
        More info here:
        http://millersmacblog.blogspot.dk/2012/06/installing-ossec-in-mac-osx-lion.html
    EOS
  end

  def patches
    # Fixes adding users on mac os > 10.6, Startup plist and compiler selection
    DATA
  end

  def test
    system "false"
  end
end
__END__
diff --git a/src/init/darwin-init.sh b/src/init/darwin-init.sh
index 2641786..7fa00f8 100755
--- a/src/init/darwin-init.sh
+++ b/src/init/darwin-init.sh
@@ -22,10 +22,6 @@ www.apple.com/DTDs/PropertyList-1.0.dtd">
        <array>
                <string>OSSEC</string>
        </array>
-       <key>Requires</key>
-       <array>
-               <string>IPFilter</string>
-       </array>
 </dict>
 </plist>
 EOF
diff --git a/active-response/firewalls/pf.sh b/active-response/firewalls/pf.sh
index 1958f3e..0c35cc5 100755
--- a/active-response/firewalls/pf.sh
+++ b/active-response/firewalls/pf.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 # Author: Rafael M. Capovilla
-# Last modified: Daniel B. Cid
+# Last modified: Ole Kristensen
 
 UNAME=`uname`
 GREP=`which grep`
@@ -35,7 +35,6 @@ if [ "x${IP}" = "x" ]; then
 fi
 
 
-
 # Blocking IP
 if [ "x${ACTION}" != "xadd" -a "x${ACTION}" != "xdelete" ]; then
    echo "$0: invalid action: ${ACTION}"
@@ -44,10 +43,22 @@ if [ "x${ACTION}" != "xadd" -a "x${ACTION}" != "xdelete" ]; then
 fi
 
 
-
-# OpenBSD and FreeBSD pf
-if [ "X${UNAME}" = "XOpenBSD" -o "X${UNAME}" = "XFreeBSD" ]; then
+# OpenBSD, Darwin and FreeBSD pf
+if [ "X${UNAME}" = "XOpenBSD" -o "X${UNAME}" = "XFreeBSD" -o "X${UNAME}" = "XDarwin" ]; then
   
+  if [ "$X{UNAME}" = "XDarwin" ]; then
+    id -u ${USER} > /dev/null 2>&1
+    if [ ! $? = 0 ]; then
+        # Only create on Mac OS X Mountain Lion 
+        /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.8" > /dev/null 2>&1
+        if [ $? != 0 ]; then
+            echo "PF config only made for Mountain Lion"
+            exit 0;
+        fi
+     fi
+  fi
+
+
   # Checking if pfctl is present
   ls ${PFCTL} > /dev/null 2>&1
   if [ ! $? = 0 ]; then
diff --git a/install.sh b/install.sh
index 781a762..143f187 100755
--- a/install.sh
+++ b/install.sh
@@ -12,3 +12,4 @@
 # Changelog 29 March 2012 - Adding hybrid mode (standalone + agent)
-
+# Changelog 08 Feb 2013 - Ole Kristensen
+# Patching for Homebrew recipe on Mountain Lion with pf support

@@ -69,5 +69,5 @@ 
        echo "DIR=\"${INSTALLDIR}\"" > ${LOCATION}
-    echo "CC=${CC}" >> ${LOCATION}
-    echo "GCC=${CC}" >> ${LOCATION}
-    echo "CLANG=clang" >> ${LOCATION}
+    echo "CC=/usr/local/bin/gcc-4*" >> ${LOCATION}
+    echo "GCC=/usr/local/bin/gcc-4*" >> ${LOCATION}
+    echo "CLANG=clang" >> ${LOCATION}
 
@@ -626,25 +627,25 @@ ConfigureServer()
             # automatically setting it up.
             # Commenting it out in case I change my mind about it
             # later.
-            #if [ "X`sh ./src/init/fw-check.sh`" = "XPF" ]; then
-            #    echo ""
-            #    $ECHO "   - ${pfenable} ($yes/$no) [$yes]: "
-            #    if [ "X${USER_ENABLE_PF}" = "X" ]; then
-            #        read PFENABLE
-            #    else
-            #        PFENABLE=${USER_ENABLE_PF}
-            #    fi
-            #
-            #    echo ""
-            #    case $PFENABLE in
-            #        $nomatch)
-            #            echo "     - ${nopf}"
-            #            ;;
-            #        *)
-            #            AddPFTable
-            #            ;;
-            #    esac
-            #fi
+            if [ "X`sh ./src/init/fw-check.sh`" = "XPF" ]; then
+                echo ""
+                $ECHO "   - ${pfenable} ($yes/$no) [$yes]: "
+                if [ "X${USER_ENABLE_PF}" = "X" ]; then
+                    read PFENABLE
+                else
+                    PFENABLE=${USER_ENABLE_PF}
+                fi
+            
+                echo ""
+                case $PFENABLE in
+                    $nomatch)
+                        echo "     - ${nopf}"
+                        ;;
+                    *)
+                        AddPFTable
+                        ;;
+                esac
+            fi
 
             echo "  </global>" >> $NEWCONFIG
             ;;
diff --git a/src/init/fw-check.sh b/src/init/fw-check.sh
index c8fde4c..7ba3ede 100755
--- a/src/init/fw-check.sh
+++ b/src/init/fw-check.sh
@@ -1,6 +1,5 @@
 #!/bin/sh
 
-
 # Checking which firewall to use.
 UNAME=`uname`
 FILE="";
@@ -24,9 +23,17 @@ if [ "X${UNAME}" = "XFreeBSD" ]; then
     fi    
 
 # Darwin
-elif [ "X${UNAME}" = "Darwin" ]; then
-    echo "IPFW";
-    FILE="ipfw_mac.sh";
+elif [ "X${UNAME}" = "XDarwin" ]; then
+    # Mountain Lion uses pf
+    /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.8" > /dev/null 2>&1
+    if [ $? = 0 ]; then
+        # Firewall is PF
+        FILE="pf.sh";
+        echo "PF";
+    else
+        echo "IPFW";
+        FILE="ipfw_mac.sh";
+    fi
         
 elif [ "X${UNAME}" = "XOpenBSD" ]; then
     if [ $? = 0 ]; then
diff --git a/src/InstallAgent.sh b/src/InstallAgent.sh
index 4dcd94c..b8fa594 100755
--- a/src/InstallAgent.sh
+++ b/src/InstallAgent.sh
@@ -68,7 +68,7 @@ elif [ "$UNAME" = "Darwin" ]; then
     if [ ! $? = 0 ]; then
 
         # Creating for 10.5
-        /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.5.|10.6" > /dev/null 2>&1
+        /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.5.|10.6|10.7|10.8" > /dev/null 2>&1
         if [ $? = 0 ]; then
             chmod +x ./init/osx105-addusers.sh
             ./init/osx105-addusers.sh
diff --git a/src/InstallServer.sh b/src/InstallServer.sh
index 3c9dd49..1d5dd86 100755
--- a/src/InstallServer.sh
+++ b/src/InstallServer.sh
@@ -82,7 +82,7 @@ elif [ "$UNAME" = "Darwin" ]; then
     if [ ! $? = 0 ]; then
 
         # Creating for 10.5 and 10.6
-        /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.5.|10.6" > /dev/null 2>&1
+        /usr/bin/sw_vers 2>/dev/null| grep "ProductVersion" | grep -E "10.5.|10.6|10.7|10.8" > /dev/null 2>&1
         if [ $? = 0 ]; then
             chmod +x ./init/osx105-addusers.sh
             ./init/osx105-addusers.sh
