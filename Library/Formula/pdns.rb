require 'formula'

class Pdns < Formula
  homepage 'http://wiki.powerdns.com'
  url 'http://downloads.powerdns.com/releases/pdns-3.1.tar.gz'
  sha256 '1400f7bd659207c0b1f4b8296092e559a7b7bf6a2434951970217d9af06922a1'

  option 'pgsql', 'Enable the PostgreSQL backend'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'lua'
  depends_on 'sqlite'
  depends_on :postgresql if build.include? 'pgsql'

  def patches
    # Patches from @justinclift:
    # 1 x patch to find correct SQLite path
    # 1 x patch (2 parts) to correct LDFLAGS, so PostgreSQL compiles
    #
    # Upstream patches (will be in next PowerDNS release)
    # 1 x patch to support compiling on OSX 10.8
    #   from http://wiki.powerdns.com/trac/changeset/2708
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-lua",
            "--with-sqlite3",
            "--with-sqlite=#{Formula.factory("sqlite").opt_prefix}"]

    # Include the PostgreSQL backend if requested
    if build.include? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    # Find Homebrew's Lua
    lua = Formula.factory("lua")
    ENV.append "LUA_CFLAGS", "-I#{lua.include}"
    ENV.append "LUA_LIBS", "-L#{lua.lib}"

    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make install"

  end
end

__END__
--- pdns-3.1/configure_orig	2012-09-02 06:16:02.000000000 +1000
+++ pdns-3.1/configure	2012-09-02 06:18:16.000000000 +1000
@@ -18398,7 +18398,7 @@
 # Check whether --with-sqlite was given.
 if test "${with_sqlite+set}" = set; then :
   withval=$with_sqlite; SQLITE_lib_check="$withval/lib/sqlite $with_sqlite/lib"
-        SQLITE_inc_check="$withval/include/sqlite"
+        SQLITE_inc_check="$withval/include"
 else
   SQLITE_lib_check="/usr/local/sqlite/lib/sqlite /usr/local/lib/sqlite /opt/pgsql/lib/sqlite /usr/lib/sqlite /usr/local/sqlite/lib /usr/local/lib /opt/sqlite/lib /usr/lib /usr/lib64"
         SQLITE_inc_check="/usr/local/sqlite/include/sqlite /usr/local/include/sqlite/ /usr/local/include /opt/sqlite/include/sqlite /opt/sqlite/include /usr/include/ /usr/include/sqlite"
@@ -18723,7 +18723,7 @@
 		freebsd*)
 			;;
 		*)
-			modulelibs="$modulelibs -lresolv -lnsl"
+			modulelibs="$modulelibs -lresolv"
 			;;
 		esac
 	fi
--- pdns-3.1/modules/gpgsqlbackend/Makefile.in_orig	2012-09-03 16:17:56.000000000 +1000
+++ pdns-3.1/modules/gpgsqlbackend/Makefile.in	2012-09-03 16:20:32.000000000 +1000
@@ -262,8 +262,7 @@
 libgpgsqlbackend_la_SOURCES = gpgsqlbackend.cc gpgsqlbackend.hh \
 		spgsql.hh spgsql.cc
 
-libgpgsqlbackend_la_LDFLAGS = -module -avoid-version @PGSQL_lib@ -Wl,-Bstatic -lpq \
-	-Wl,-Bdynamic 
+libgpgsqlbackend_la_LDFLAGS = -module -avoid-version @PGSQL_lib@ -lpq
 
 libgpgsqlbackend_la_LIBADD = -lssl @LIBCRYPT@ -lcrypto
 all: all-am
--- pdns-3.1/pdns/cachecleaner.hh_orig	2012-09-11 18:01:49.000000000 +1000
+++ pdns-3.1/pdns/cachecleaner.hh	2012-09-11 18:03:17.000000000 +1000
@@ -18,7 +18,7 @@
 //  cout<<"Need to trim "<<toTrim<<" from cache to meet target!\n";
 
   typedef typename T::template nth_index<1>::type sequence_t;
-  sequence_t& sidx=collection.get<1>();
+  sequence_t& sidx=collection.template get<1>();
 
   unsigned int tried=0, lookAt, erased=0;
 
@@ -62,8 +62,8 @@
 template <typename T> void moveCacheItemToFrontOrBack(T& collection, typename T::iterator& iter, bool front)
 {
   typedef typename T::template nth_index<1>::type sequence_t;
-  sequence_t& sidx=collection.get<1>();
-  typename sequence_t::iterator si=collection.project<1>(iter);
+  sequence_t& sidx=collection.template get<1>();
+  typename sequence_t::iterator si=collection.template project<1>(iter);
   if(front)
     sidx.relocate(sidx.begin(), si); // at the beginning of the delete queue
   else
