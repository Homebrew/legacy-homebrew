require 'formula'

class Autopsy < Formula
  homepage 'http://www.sleuthkit.org/autopsy/index.php'
  url 'https://downloads.sourceforge.net/project/autopsy/autopsy/2.24/autopsy-2.24.tar.gz'
  sha1 '084a6554a1494f5f34df4a5a3635c8d3dc3b8822'

  depends_on 'sleuthkit'
  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  # fixes weird configure script that wouldn't work nicely with homebrew
  patch :DATA

  def autcfg; <<-EOS.undent
    # Autopsy configuration settings

    # when set to 1, the server will stop after it receives no
    # connections for STIMEOUT seconds.
    $USE_STIMEOUT = 0;
    $STIMEOUT = 3600;

    # number of seconds that child waits for input from client
    $CTIMEOUT = 15;

    # set to 1 to save the cookie value in a file (for scripting)
    $SAVE_COOKIE = 1;

    $INSTALLDIR = '#{prefix}';


    # System Utilities
    $GREP_EXE = '/usr/bin/grep';
    $FILE_EXE = '/usr/bin/file';
    $MD5_EXE = '/sbin/md5';
    $SHA1_EXE = '/usr/bin/shasum';


    # Directories
    $TSKDIR = '/usr/local/bin/';

    # Homebrew users can install NSRL database and change this variable later
    $NSRLDB = '';

    # Evidence locker location
    $LOCKDIR = '#{var}/lib/autopsy';
    EOS
  end

  def install
    (var+"lib/autopsy").mkpath
    mv 'lib', 'libexec'
    prefix.install %w{ global.css help libexec pict }
    prefix.install Dir['*.txt']
    (prefix+"conf.pl").write autcfg
    inreplace 'base/autopsy.base', '/tmp/autopsy', prefix
    inreplace 'base/autopsy.base', 'lib/define.pl', "#{libexec}/define.pl"
    bin.install 'base/autopsy.base' => 'autopsy'
  end

  def caveats; <<-EOS.undent
    By default, the evidence locker is in:
      #{var}/lib/autopsy
    EOS
  end
end

__END__
diff --git a/base/autopsy.base b/base/autopsy.base
index 3b3bbdc..a0d2632 100644
--- a/base/autopsy.base
+++ b/base/autopsy.base
@@ -1,3 +1,6 @@
+#!/usr/bin/perl -wT
+use lib '/tmp/autopsy/';
+use lib '/tmp/autopsy/libexec/';
 #
 # autopsy gui server
 # Autopsy Forensic Browser
