class Couchdb < Formula
  desc "CouchDB is a document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz"
  sha256 "5a601b173733ce3ed31b654805c793aa907131cd70b06d03825f169aa48c8627"
  revision 3

  stable do
    # Support Erlang/OTP 18.0 compatibility, see upstream #95cb436
    # It will be in the next CouchDB point release, likely 1.6.2.
    patch :DATA
  end

  bottle do
    cellar :any
    revision 2
    sha256 "6ad83e87adb54bcae6ad83102ab1e72371f7841631910f04e5a2d4101d0dec86" => :el_capitan
    sha256 "98736f7c3da052c1004fda0d42f946f6f55a3a60e962312a28919af86a778a77" => :yosemite
    sha256 "7378f73cb60192192340ebb6b1bba9ceb80569daa15d29abdaa6f9c8d88ddb32" => :mavericks
  end

  head do
    url "https://git-wip-us.apache.org/repos/asf/couchdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "autoconf-archive" => :build
    depends_on "pkg-config" => :build
    depends_on "help2man" => :build
  end

  depends_on "spidermonkey"
  depends_on "icu4c"
  depends_on "erlang"
  depends_on "curl" if MacOS.version <= :leopard

  def install
    # CouchDB >=1.3.0 supports vendor names and versioning
    # in the welcome message
    inreplace "etc/couchdb/default.ini.tpl.in" do |s|
      s.gsub! "%package_author_name%", "Homebrew"
      s.gsub! "%version%", pkg_version
    end

    if build.devel? || build.head?
      # workaround for the auto-generation of THANKS file which assumes
      # a developer build environment incl access to git sha
      touch "THANKS"
      system "./bootstrap"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-init",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include",
                          "--with-js-include=#{HOMEBREW_PREFIX}/include/js",
                          "--with-js-lib=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make", "install"

    # Use our plist instead to avoid faffing with a new system user.
    (prefix+"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    (lib+"couchdb/bin/couchjs").chmod 0755
    (var+"lib/couchdb").mkpath
    (var+"log/couchdb").mkpath
  end

  def post_install
    # default.ini is owned by CouchDB and marked not user-editable
    # and must be overwritten to ensure correct operation.
    if (etc/"couchdb/default.ini.default").exist?
      # but take a backup just in case the user didn't read the warning.
      mv etc/"couchdb/default.ini", etc/"couchdb/default.ini.old"
      mv etc/"couchdb/default.ini.default", etc/"couchdb/default.ini"
    end
  end

  plist_options :manual => "couchdb"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    To test CouchDB run:
        curl http://127.0.0.1:5984/

    The reply should look like:
        {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
    EOS
  end

  test do
    # ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"
  end
end
__END__
commit 95cb436be30305efa091809813b64ef31af968c8
Author: Dave Cottlehuber <dch@apache.org>
Date:   Fri Jun 26 10:31:27 2015 +0200

    build: support OTP-18.0

diff --git a/INSTALL.Unix b/INSTALL.Unix
index f66f98c..4c63bc8 100644
--- a/INSTALL.Unix
+++ b/INSTALL.Unix
@@ -39,7 +39,7 @@ Dependencies

 You should have the following installed:

- * Erlang OTP (>=R14B01, =<R17) (http://erlang.org/)
+ * Erlang OTP (>=R14B01, =<R18) (http://erlang.org/)
  * ICU                          (http://icu-project.org/)
  * OpenSSL                      (http://www.openssl.org/)
  * Mozilla SpiderMonkey (1.8.5) (http://www.mozilla.org/js/spidermonkey/)
diff --git a/INSTALL.Windows b/INSTALL.Windows
index 29c69b0..1ca04fd 100644
--- a/INSTALL.Windows
+++ b/INSTALL.Windows
@@ -29,7 +29,7 @@ Dependencies

 You will need the following installed:

- * Erlang OTP (>=14B01, <R17)    (http://erlang.org/)
+ * Erlang OTP (>=14B01, <R18)    (http://erlang.org/)
  * ICU        (>=4.*)            (http://icu-project.org/)
  * OpenSSL    (>=0.9.8r)         (http://www.openssl.org/)
  * Mozilla SpiderMonkey (=1.8.5) (http://www.mozilla.org/js/spidermonkey/)
diff --git a/configure.ac b/configure.ac
index 103f029..bf9ffc4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -411,7 +411,7 @@ esac

 { $as_echo "$as_me:${as_lineno-$LINENO}: checking Erlang version compatibility" >&5
 $as_echo_n "checking Erlang version compatibility... " >&6; }
-erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 17 (erts-6.0)"
+erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 18 (erts-7.0)"

 version="`${ERL} -version 2>&1 | ${SED} 's/[[^0-9]]/ /g'` 0 0 0"
 major_version=`echo $version | ${AWK} "{print \\$1}"`
@@ -419,7 +419,7 @@ minor_version=`echo $version | ${AWK} "{print \\$2}"`
 patch_version=`echo $version | ${AWK} "{print \\$3}"`
 echo -n "detected Erlang version: $major_version.$minor_version.$patch_version..."

-if test $major_version -lt 5 -o $major_version -gt 6; then
+if test $major_version -lt 5 -o $major_version -gt 7; then
     as_fn_error $? "$erlang_version_error major_version does not match" "$LINENO" 5
 fi

@@ -438,9 +438,9 @@ otp_release="`\
 AC_SUBST(otp_release)

 AM_CONDITIONAL([USE_OTP_NIFS],
-    [can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17)")])
+    [can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17|18)")])
 AM_CONDITIONAL([USE_EJSON_COMPARE_NIF],
-    [can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17)")])
+    [can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17|18)")])

 has_crypto=`\
     ${ERL} -eval "\
diff --git a/share/doc/src/install/unix.rst b/share/doc/src/install/unix.rst
index 76fe922..904c128 100644
--- a/share/doc/src/install/unix.rst
+++ b/share/doc/src/install/unix.rst
@@ -52,7 +52,7 @@ Dependencies

 You should have the following installed:

-* `Erlang OTP (>=R14B01, =<R17) <http://erlang.org/>`_
+* `Erlang OTP (>=R14B01, =<R18) <http://erlang.org/>`_
 * `ICU                          <http://icu-project.org/>`_
 * `OpenSSL                      <http://www.openssl.org/>`_
 * `Mozilla SpiderMonkey (1.8.5) <http://www.mozilla.org/js/spidermonkey/>`_
diff --git a/share/doc/src/install/windows.rst b/share/doc/src/install/windows.rst
index b7b66af..494ef65 100644
--- a/share/doc/src/install/windows.rst
+++ b/share/doc/src/install/windows.rst
@@ -90,7 +90,7 @@ Dependencies

 You should have the following installed:

-* `Erlang OTP (>=14B01, <R17)    <http://erlang.org/>`_
+* `Erlang OTP (>=14B01, <R18)    <http://erlang.org/>`_
 * `ICU        (>=4.*)            <http://icu-project.org/>`_
 * `OpenSSL    (>0.9.8r)          <http://www.openssl.org/>`_
 * `Mozilla SpiderMonkey (=1.8.5) <http://www.mozilla.org/js/spidermonkey/>`_
--- a/configure	2015-06-27 12:56:30.000000000 +0200
+++ b/configure	2015-06-27 12:58:38.000000000 +0200
@@ -18532,7 +18532,7 @@

 { $as_echo "$as_me:${as_lineno-$LINENO}: checking Erlang version compatibility" >&5
 $as_echo_n "checking Erlang version compatibility... " >&6; }
-erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 17 (erts-6.0)"
+erlang_version_error="The installed Erlang version must be >= R14B (erts-5.8.1) and =< 18 (erts-7.0)"

 version="`${ERL} -version 2>&1 | ${SED} 's/[^0-9]/ /g'` 0 0 0"
 major_version=`echo $version | ${AWK} "{print \\$1}"`
@@ -18540,7 +18540,7 @@
 patch_version=`echo $version | ${AWK} "{print \\$3}"`
 echo -n "detected Erlang version: $major_version.$minor_version.$patch_version..."

-if test $major_version -lt 5 -o $major_version -gt 6; then
+if test $major_version -lt 5 -o $major_version -gt 7; then
     as_fn_error $? "$erlang_version_error major_version does not match" "$LINENO" 5
 fi

@@ -18559,7 +18559,7 @@



- if can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17)"); then
+ if can_use_nifs=$(echo $otp_release | grep -E "^(R14B|R15|R16|17|18)"); then
   USE_OTP_NIFS_TRUE=
   USE_OTP_NIFS_FALSE='#'
 else
@@ -18567,7 +18567,7 @@
   USE_OTP_NIFS_FALSE=
 fi

- if can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17)"); then
+ if can_use_ejson=$(echo $otp_release | grep -E "^(R14B03|R15|R16|17|18)"); then
   USE_EJSON_COMPARE_NIF_TRUE=
   USE_EJSON_COMPARE_NIF_FALSE='#'
 else
