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
diff --git a/install.sh b/install.sh
index 781a762..143f187 100755
--- a/install.sh
+++ b/install.sh
@@ -69,5 +69,5 @@ 
        echo "DIR=\"${INSTALLDIR}\"" > ${LOCATION}
-    echo "CC=${CC}" >> ${LOCATION}
-    echo "GCC=${CC}" >> ${LOCATION}
-    echo "CLANG=clang" >> ${LOCATION}
+    echo "CC=/usr/local/bin/gcc-4*" >> ${LOCATION}
+    echo "GCC=/usr/local/bin/gcc-4*" >> ${LOCATION}
+    echo "CLANG=clang" >> ${LOCATION}
 
diff --git a/etc/preloaded-vars.conf b/etc/preloaded-vars.conf
index 45a2f7e..cf5c345 100755
--- a/etc/preloaded-vars.conf
+++ b/etc/preloaded-vars.conf
@@ -16,7 +16,7 @@
 # It can be "en", "br", "tr", "it", "de" or "pl".
 # In case of an invalid language, it will default
 # to English "en" 
-#USER_LANGUAGE="en"     # For english
+USER_LANGUAGE="en"     # For english
 #USER_LANGUAGE="br"     # For portuguese
 
 
@@ -28,13 +28,13 @@
 # USER_INSTALL_TYPE defines the installation type to
 # be used during install. It can only be "local",
 # "agent" or "server".
-#USER_INSTALL_TYPE="local"
+USER_INSTALL_TYPE="local"
 #USER_INSTALL_TYPE="agent"
 #USER_INSTALL_TYPE="server"
 
 
 # USER_DIR defines the location to install ossec
-#USER_DIR="/var/ossec"
+USER_DIR="/var/ossec"
 
 
 # If USER_DELETE_DIR is set to "y", the directory
@@ -44,19 +44,19 @@
 
 # If USER_ENABLE_ACTIVE_RESPONSE is set to "n",
 # active response will be disabled.
-#USER_ENABLE_ACTIVE_RESPONSE="y"
+USER_ENABLE_ACTIVE_RESPONSE="y"
 
 
 # If USER_ENABLE_SYSCHECK is set to "y", 
 # syscheck will be enabled. Set to "n" to
 # disable it.
-#USER_ENABLE_SYSCHECK="y"
+USER_ENABLE_SYSCHECK="y"
 
 
 # If USER_ENABLE_ROOTCHECK is set to "y",
 # rootcheck will be enabled. Set to "n" to
 # disable it.
-#USER_ENABLE_ROOTCHECK="y"
+USER_ENABLE_ROOTCHECK="y"
 
 
 # If USER_UPDATE is set to anything, the update
@@ -93,7 +93,7 @@
 ### Server/Local Installation variables. ###
 
 # USER_ENABLE_EMAIL enables or disables email alerting.
-#USER_ENABLE_EMAIL="y"
+USER_ENABLE_EMAIL="y"
 
 # USER_EMAIL_ADDRESS defines the destination e-mail of the alerts.
 #USER_EMAIL_ADDRESS="dcid@test.ossec.net"
@@ -108,15 +108,15 @@
 
 # USER_ENABLE_FIREWALL_RESPONSE enables or disables
 # the firewall response.
-#USER_ENABLE_FIREWALL_RESPONSE="y"
+USER_ENABLE_FIREWALL_RESPONSE="y"
 
 
 # Enable PF firewall (OpenBSD and FreeBSD only)
-#USER_ENABLE_PF="y"
+USER_ENABLE_PF="y"
 
 
 # PF table to use (OpenBSD and FreeBSD only).
-#USER_PF_TABLE="ossec_fwtable"
+USER_PF_TABLE="ossec_fwtable"
 
 
 # USER_WHITE_LIST is a list of IPs or networks
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
