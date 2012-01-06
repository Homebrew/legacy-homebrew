require 'formula'

class Fbcmd < Formula
  # There are currently no tarballs.
  homepage 'http://fbcmd.dtompkins.com'
  head 'https://github.com/dtompkins/fbcmd.git'

  def patches
    # The executable file that will run fbcmd and a dummy update script.
    DATA
  end

  def install
    bin.install 'fbcmd'
    (lib + 'fbcmd').install 'fbcmd.php'
    (lib + 'fbcmd').install 'fbcmd_update_dummy.php' => 'fbcmd_update.php'
    (lib + 'fbcmd').install 'facebook'
  end
end
__END__
diff --git c/fbcmd i/fbcmd
new file mode 100755
index 0000000..b8fb517
--- /dev/null
+++ i/fbcmd
@@ -0,0 +1,3 @@
+#!/bin/bash
+php -d date.timezone="$(systemsetup -gettimezone | awk '{print $3}')" "$(dirname $(dirname "$0"))/lib/fbcmd/fbcmd.php" "$@"
+

diff --git c/fbcmd_update_dummy.php i/fbcmd_update_dummy.php
new file mode 100755
index 0000000..1384fc8
--- /dev/null
+++ i/fbcmd_update_dummy.php
@@ -0,0 +1,7 @@
+#!/usr/bin/php
+<?php
+
+print "Error: fbcmd is managed by Homebrew"
+
+?>
+

