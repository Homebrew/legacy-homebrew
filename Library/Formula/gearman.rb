require 'formula'

class Gearman < Formula
  homepage 'http://gearman.org/'
  url 'http://launchpad.net/gearmand/trunk/0.28/+download/gearmand-0.28.tar.gz'
  md5 '43fc281297489a53d4ee081e33c728db'

  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'ossp-uuid'

  # gearman-0.28 build error "ld: library not found for -lrt"
  # see https://bugs.launchpad.net/gearmand/+bug/951198
  # fixed upstream for 0.29
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

      To start gearmand manually:
        gearmand -d
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>Program</key>
    <string>#{sbin}/gearmand</string>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
  </dict>
</plist>
    EOPLIST
  end
end

__END__
--- gearmand-0.28/configure.ac.orig	2012-03-09 14:56:28.000000000 -0500
+++ gearmand-0.28/configure.ac	2012-03-09 14:56:58.000000000 -0500
@@ -184,12 +184,12 @@
 # Check for -lm
 AC_CHECK_LIB([m], [floor], 
              [
-              M_LIB="-lrt"
+              M_LIB="-lm"
               AC_SUBST(M_LIB)
-              AC_DEFINE([HAVE_LIBRT], [ 1 ], [Have clock_gettime])
+              AC_DEFINE([HAVE_LIBM], [ 1 ], [Have floor])
               ], 
              [
-              AC_DEFINE([HAVE_LIBRT], [ 0 ], [Have clock_gettime])
+              AC_DEFINE([HAVE_LIBM], [ 0 ], [Have floor])
               ])
 
 AC_CHECK_FUNC(setsockopt, [], [AC_CHECK_LIB(socket, setsockopt)])

--- gearmand-0.28/configure.orig	2012-03-09 15:06:11.000000000 -0500
+++ gearmand-0.28/configure	2012-03-09 15:06:45.000000000 -0500
@@ -25755,16 +25790,16 @@
 $as_echo "$ac_cv_lib_m_floor" >&6; }
 if test "x$ac_cv_lib_m_floor" = xyes; then :
 
-              M_LIB="-lrt"
+              M_LIB="-lm"
 
 
-$as_echo "#define HAVE_LIBRT  1 " >>confdefs.h
+$as_echo "#define HAVE_LIBM  1 " >>confdefs.h
 
 
 else
 
 
-$as_echo "#define HAVE_LIBRT  0 " >>confdefs.h
+$as_echo "#define HAVE_LIBM  0 " >>confdefs.h
 
 
 fi
