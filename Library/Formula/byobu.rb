require 'formula'

class Byobu < Formula
  homepage 'http://byobu.co'
  url 'https://launchpad.net/byobu/trunk/5.73/+download/byobu_5.73.orig.tar.gz'
  sha1 'b7a27b41c7bc384394fabfe9e589ad2d0c4fcd89'

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed
  depends_on 'tmux'
  depends_on 'newt' => 'with-python'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  # Reported upstream:
  # https://bugs.launchpad.net/byobu/+bug/1285848
  def patches
    DATA
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end

__END__
diff --git a/usr/bin/byobu b/usr/bin/byobu
index a055105..8b05b31 100755
--- a/usr/bin/byobu
+++ b/usr/bin/byobu
@@ -37,15 +37,6 @@ if [ -r "$HOME/.byoburc" ]; then
 	# Ensure that this configuration is usable
 	. "$HOME/.byoburc" || mv -f "$HOME/.byoburc".orig
 fi
-if [ -z "${BYOBU_PREFIX}" ]; then
-	# Find and export the installation location prefix
-	greadlink -f . >/dev/null 2>&1 && export BYOBU_READLINK="greadlink" || export BYOBU_READLINK="readlink"
-	prefix="$(dirname $(dirname $($BYOBU_READLINK -f $0)))"
-	if [ "$prefix" != "/usr" ]; then
-		echo "export BYOBU_PREFIX='$prefix'" >> "$HOME/.byoburc"
-		. "$HOME/.byoburc"
-	fi
-fi
 export BYOBU_CHARMAP=$(locale charmap)
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
 [ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX

diff --git a/usr/bin/byobu b/usr/bin/byobu
index 8b05b31..6344efd 100755
--- a/usr/bin/byobu
+++ b/usr/bin/byobu
@@ -39,7 +39,7 @@ if [ -r "$HOME/.byoburc" ]; then
 fi
 export BYOBU_CHARMAP=$(locale charmap)
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 # Override backend if we can determine intentions from argv[0]
diff --git a/usr/bin/byobu-config b/usr/bin/byobu-config
index 9fd810f..a24ffa0 100755
--- a/usr/bin/byobu-config
+++ b/usr/bin/byobu-config
@@ -18,7 +18,7 @@
 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 PKG="byobu"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 ${BYOBU_PYTHON} "${BYOBU_PREFIX}/lib/${PKG}/include/config.py"
diff --git a/usr/bin/byobu-ctrl-a b/usr/bin/byobu-ctrl-a
index 883bc2b..894aef2 100755
--- a/usr/bin/byobu-ctrl-a
+++ b/usr/bin/byobu-ctrl-a
@@ -27,7 +27,7 @@ EOF
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 bind_to=""
diff --git a/usr/bin/byobu-disable b/usr/bin/byobu-disable
index ce96f4e..01b0c1e 100755
--- a/usr/bin/byobu-disable
+++ b/usr/bin/byobu-disable
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 byobu-launcher-uninstall
diff --git a/usr/bin/byobu-disable-prompt b/usr/bin/byobu-disable-prompt
index 4791224..ac68c93 100755
--- a/usr/bin/byobu-disable-prompt
+++ b/usr/bin/byobu-disable-prompt
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 $BYOBU_SED -i -e "/#byobu-prompt#$/d" "$HOME/.bashrc"
diff --git a/usr/bin/byobu-enable b/usr/bin/byobu-enable
index ead1c36..415f19f 100755
--- a/usr/bin/byobu-enable
+++ b/usr/bin/byobu-enable
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 byobu-launcher-install
diff --git a/usr/bin/byobu-enable-prompt b/usr/bin/byobu-enable-prompt
index 06382cd..5381aac 100755
--- a/usr/bin/byobu-enable-prompt
+++ b/usr/bin/byobu-enable-prompt
@@ -21,7 +21,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 
diff --git a/usr/bin/byobu-export b/usr/bin/byobu-export
index a89e52a..3ab1d00 100755
--- a/usr/bin/byobu-export
+++ b/usr/bin/byobu-export
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 gettext "
diff --git a/usr/bin/byobu-janitor b/usr/bin/byobu-janitor
index c7f244a..dc44ab8 100755
--- a/usr/bin/byobu-janitor
+++ b/usr/bin/byobu-janitor
@@ -21,7 +21,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 # Ensure that all updates get run immediately
diff --git a/usr/bin/byobu-launch b/usr/bin/byobu-launch
index 1dda80f..a167933 100755
--- a/usr/bin/byobu-launch
+++ b/usr/bin/byobu-launch
@@ -43,7 +43,7 @@ elif [ "$BYOBU_SOURCED_PROFILE" != "1" ] && [ "$LC_BYOBU" != "0" ] && [ "$BYOBU_
 	BYOBU_SOURCED_PROFILE=1
 	PKG="byobu"
 	[ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-	[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+	export BYOBU_PREFIX=$(brew --prefix)
 	. "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 	# Ensure that autolaunch is not explicitly disabled
 	if [ ! -r "$BYOBU_CONFIG_DIR/disable-autolaunch" ]; then
diff --git a/usr/bin/byobu-launcher b/usr/bin/byobu-launcher
index 45f95e5..14024e5 100755
--- a/usr/bin/byobu-launcher
+++ b/usr/bin/byobu-launcher
@@ -22,7 +22,7 @@ PKG="byobu"
 # ie, rather than "sudo byobu", you must run "sudo -H byobu"
 if [ -O "$HOME" ]; then
 	[ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-	[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+	export BYOBU_PREFIX=$(brew --prefix)
 	. "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 	if [ -e "$BYOBU_CONFIG_DIR/disable-autolaunch" ]; then
 		false
diff --git a/usr/bin/byobu-launcher-install b/usr/bin/byobu-launcher-install
index 78202a2..399fe20 100755
--- a/usr/bin/byobu-launcher-install
+++ b/usr/bin/byobu-launcher-install
@@ -20,7 +20,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 FLAG="$BYOBU_CONFIG_DIR/no-logout-on-detach"
diff --git a/usr/bin/byobu-launcher-uninstall b/usr/bin/byobu-launcher-uninstall
index 9f4b221..f0ba729 100755
--- a/usr/bin/byobu-launcher-uninstall
+++ b/usr/bin/byobu-launcher-uninstall
@@ -20,7 +20,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 remove_launcher() {
diff --git a/usr/bin/byobu-layout b/usr/bin/byobu-layout
index ee0ab61..ac83596 100755
--- a/usr/bin/byobu-layout
+++ b/usr/bin/byobu-layout
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 # Get the layouts directory
diff --git a/usr/bin/byobu-prompt b/usr/bin/byobu-prompt
index 3720be3..9a86f6a 100755
--- a/usr/bin/byobu-prompt
+++ b/usr/bin/byobu-prompt
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 echo
diff --git a/usr/bin/byobu-quiet b/usr/bin/byobu-quiet
index 3c8c77a..cbcbeb3 100755
--- a/usr/bin/byobu-quiet
+++ b/usr/bin/byobu-quiet
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 FLAG="$BYOBU_CONFIG_DIR/status.disable"
diff --git a/usr/bin/byobu-reconnect-sockets b/usr/bin/byobu-reconnect-sockets
index 46f28a5..58e6a11 100755
--- a/usr/bin/byobu-reconnect-sockets
+++ b/usr/bin/byobu-reconnect-sockets
@@ -25,7 +25,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 case "$-" in
diff --git a/usr/bin/byobu-select-backend b/usr/bin/byobu-select-backend
index 19298a2..81aa390 100755
--- a/usr/bin/byobu-select-backend
+++ b/usr/bin/byobu-select-backend
@@ -20,7 +20,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 usage () {
diff --git a/usr/bin/byobu-select-profile b/usr/bin/byobu-select-profile
index 45bb4b1..9c77e32 100755
--- a/usr/bin/byobu-select-profile
+++ b/usr/bin/byobu-select-profile
@@ -24,7 +24,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 TEXTDOMAIN="$PKG"
diff --git a/usr/bin/byobu-select-session b/usr/bin/byobu-select-session
index 34bc552..08b6f6b 100755
--- a/usr/bin/byobu-select-session
+++ b/usr/bin/byobu-select-session
@@ -18,7 +18,7 @@
 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 PKG="byobu"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 ${BYOBU_PYTHON} "${BYOBU_PREFIX}/lib/${PKG}/include/select-session.py"
diff --git a/usr/bin/byobu-shell b/usr/bin/byobu-shell
index a56b632..3971d85 100755
--- a/usr/bin/byobu-shell
+++ b/usr/bin/byobu-shell
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 FLAG="$BYOBU_CONFIG_DIR/.welcome-displayed"
diff --git a/usr/bin/byobu-silent b/usr/bin/byobu-silent
index 3caf124..894570e 100755
--- a/usr/bin/byobu-silent
+++ b/usr/bin/byobu-silent
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 FLAG="$BYOBU_CONFIG_DIR/status.disable"
diff --git a/usr/bin/byobu-status b/usr/bin/byobu-status
index c4684aa..60cacbd 100755
--- a/usr/bin/byobu-status
+++ b/usr/bin/byobu-status
@@ -20,7 +20,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 # Make sure status is not disabled
diff --git a/usr/bin/byobu-status-detail b/usr/bin/byobu-status-detail
index 5582d60..ef7e1c3 100755
--- a/usr/bin/byobu-status-detail
+++ b/usr/bin/byobu-status-detail
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 if which vim >/dev/null && `vim --version | grep -q +folding`; then
diff --git a/usr/bin/byobu-ugraph b/usr/bin/byobu-ugraph
index bf33f34..52f2789 100755
--- a/usr/bin/byobu-ugraph
+++ b/usr/bin/byobu-ugraph
@@ -26,7 +26,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 script_name=${0##*/}
diff --git a/usr/bin/byobu-ulevel b/usr/bin/byobu-ulevel
index 877de32..59e3fcb 100755
--- a/usr/bin/byobu-ulevel
+++ b/usr/bin/byobu-ulevel
@@ -37,7 +37,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 
 circles_2=(○ ●)
diff --git a/usr/lib/byobu/include/dirs b/usr/lib/byobu/include/dirs
index cfb67d8..f43544c 100755
--- a/usr/lib/byobu/include/dirs
+++ b/usr/lib/byobu/include/dirs
@@ -22,7 +22,7 @@ PKG="byobu"
 
 # Some users build and install byobu themselves, rather than from a distro
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -n "$BYOBU_PREFIX" ] || BYOBU_PREFIX="/usr"
+BYOBU_PREFIX=$(brew --prefix)
 
 # Create and export the user configuration directory
 if [ -d "$BYOBU_CONFIG_DIR" ]; then
diff --git a/usr/lib/byobu/include/toggle-utf8 b/usr/lib/byobu/include/toggle-utf8
index 84fcf50..c775582 100755
--- a/usr/lib/byobu/include/toggle-utf8
+++ b/usr/lib/byobu/include/toggle-utf8
@@ -19,7 +19,7 @@
 
 PKG="byobu"
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
-[ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
+export BYOBU_PREFIX=$(brew --prefix)
 . "${BYOBU_PREFIX}/lib/${PKG}/include/common"
 [ -r "$BYOBU_CONFIG_DIR/statusrc" ] && . "$BYOBU_CONFIG_DIR/statusrc"
 
