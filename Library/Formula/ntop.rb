require 'formula'

class Ntop < Formula
  homepage 'http://www.ntop.org/'
  url 'http://downloads.sourceforge.net/project/ntop/ntop/Stable/ntop-5.0.tar.gz'
  sha1 '1395bc214ee3b76eba5dfeec436713a5ab15d835'
  head 'https://svn.ntop.org/svn/ntop/trunk/ntop/'

  depends_on :autoconf
  depends_on :libtool
  depends_on 'rrdtool'
  depends_on 'geoip'
  depends_on 'gdbm'

  # Cleaning removes the #{prefix}/var folder, which breaks ntop.
  skip_clean :all

  def patches
    # Use Curl instead of wget when installing
    DATA
  end

  def install
    # we have to be verbose; SVN might ask about certificates
    ENV['HOMEBREW_VERBOSE'] = 'ON'
    system "./autogen.sh","--noconfig"
    # ./configure symlinks a hard-coded glibtool, use which instead
    inreplace "configure" do |s|
      s.gsub! "/usr/bin/glibtool", (which "glibtool")
    end
    # Configure gets the localedir wrong and complains.  Set it and create it.
    ENV['LOCALEDIR'] = share/"locale"
    FileUtils.mkdir_p ENV['LOCALEDIR']
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ntop", "--version"
  end
end
__END__
diff -NEaur a/Makefile.am b/Makefile.am
--- a/Makefile.am	2012-07-09 13:20:46.000000000 +0200
+++ b/Makefile.am	2012-08-07 01:46:04.000000000 +0200
@@ -383,7 +383,7 @@
 	@mv oui.txt.gz oui.txt.gz.old
 	@echo "(old oui.txt.gz file is now oui.txt.gz.old)"
 	@echo ""
-	@wget -c http://standards.ieee.org/regauth/oui/oui.txt
+	@wget -C - http://standards.ieee.org/regauth/oui/oui.txt
 	@gzip oui.txt
 	@echo ""
 	@echo ""
@@ -398,7 +398,7 @@
 
 # download the Novell SAP Protocol information table
 #dnsapt:
-#	@(cd Internet; wget -c http://www.iana.org/assignments/novell-sap-numbers)
+#	@(cd Internet; curl -C - http://www.iana.org/assignments/novell-sap-numbers)
 
 # download the passive ethernet fingerprint database
 dnetter:
@@ -424,7 +424,7 @@
         done
 	@echo ""
 	@echo "...Downloading new file..."
-	@wget -O $(ETTER_PASSIVE_FILE) \
+	@curl -o $(ETTER_PASSIVE_FILE) \
 		$(ETTER_PASSIVE_DOWNLOAD_FROM)/$(ETTER_PASSIVE_FILE)?$(ETTER_PASSIVE_DOWNLOAD_PARMS)
 	@echo ""
 	@echo "gziping downloaded file..."
diff -NEaur a/acinclude.m4.ntop b/acinclude.m4.ntop
--- a/acinclude.m4.ntop	2004-03-09 18:19:57.000000000 +0100
+++ b/acinclude.m4.ntop	2012-08-07 01:46:04.000000000 +0200
@@ -148,7 +148,7 @@
     echo "*???                 It's quite easy and does NOT require root:"
     echo "*"
     echo "*   Download $1 $2 from gnu"
-    echo "*     \$ wget http://ftp.gnu.org/gnu/$1/$1-$2.tar.gz"
+    echo "*     \$ curl http://ftp.gnu.org/gnu/$1/$1-$2.tar.gz"
     echo "*"
     echo "*   Untar it"
     echo "*     \$ tar xfvz $1-$2.tar.gz"
diff -NEaur a/autogen.sh b/autogen.sh
--- a/autogen.sh	2012-02-20 11:35:43.000000000 +0100
+++ b/autogen.sh	2012-08-07 01:46:04.000000000 +0200
@@ -202,13 +202,11 @@
   GNU_OR_DIE=0
 }
 
-WGET=`find_command 'wget*'`
-($WGET --version) < /dev/null > /dev/null 2>&1 ||
+CURL=`find_command 'curl*'`
+($CURL --version) < /dev/null > /dev/null 2>&1 ||
 {
   echo
-  echo "You must have wget installed to compile $progname."
-  echo "Download the appropriate package for your distribution, or get the"
-  echo "source tarball from ftp://ftp.gnu.org/pub/gnu/wget"
+  echo "You must have curl installed to compile $progname."
   GNU_OR_DIE=0
 }
 
diff -NEaur a/configure.in b/configure.in
--- a/configure.in	2012-07-18 01:31:51.000000000 +0200
+++ b/configure.in	2012-08-07 01:46:04.000000000 +0200
@@ -1750,7 +1750,7 @@
    if test -f "3rd_party/GeoLiteCity.dat.gz"; then
      cp 3rd_party/GeoLiteCity.dat.gz .
    else
-     wget http://www.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
+     curl http://www.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
    fi
 
    gunzip GeoLiteCity.dat.gz
@@ -1764,7 +1764,7 @@
    if test -f "3rd_party/GeoIPASNum.dat.gz"; then
      cp 3rd_party/GeoIPASNum.dat.gz .
    else
-     wget http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
+     curl http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
    fi
 
    gunzip GeoIPASNum.dat.gz
diff -NEaur a/misc/configure.in.lua b/misc/configure.in.lua
--- a/misc/configure.in.lua	2009-08-11 10:24:46.000000000 +0200
+++ b/misc/configure.in.lua	2012-08-07 01:46:04.000000000 +0200
@@ -5,7 +5,7 @@
 if test -f "$LUA_VERSION.tar.gz"; then
    echo "Lua already present on this machine"
 else
-   wget http://www.lua.org/ftp/$LUA_VERSION.tar.gz
+   curl http://www.lua.org/ftp/$LUA_VERSION.tar.gz
 fi
 
 tar xvfz $LUA_VERSION.tar.gz
diff -NEaur a/utils/AS-list.sh b/utils/AS-list.sh
--- a/utils/AS-list.sh	2006-02-15 22:20:25.000000000 +0100
+++ b/utils/AS-list.sh	2012-08-07 01:46:04.000000000 +0200
@@ -6,7 +6,7 @@
 
 for AS in 1221 4637; do
   tmp=/tmp/AS-list-$AS
-  wget -O $tmp -N http://bgp.potaroo.net/as$AS/bgp-table-asorigin.txt
+  curl -o $tmp -z $tmp http://bgp.potaroo.net/as$AS/bgp-table-asorigin.txt
   cat $tmp | \
     grep -v Withdrawn | \
     cut -d+ -f-1 | \
