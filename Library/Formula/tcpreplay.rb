require 'formula'

class Tcpreplay < Formula
  homepage 'http://tcpreplay.synfin.net'
  url 'http://downloads.sourceforge.net/project/tcpreplay/tcpreplay/3.4.4/tcpreplay-3.4.4.tar.gz'
  sha1 '9e4cca81cfbfb919f8759e1a27ce1b3b963ff3b8'

  # Hard-code use of dylib instead of so
  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index d41d433..9514748 100755
--- a/configure
+++ b/configure
@@ -9872,7 +9872,7 @@ darwin* | rhapsody*)
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'
+  shrext_cmds=".dylib"
 
   sys_lib_search_path_spec="$sys_lib_search_path_spec /usr/local/lib"
   sys_lib_dlsearch_path_spec='/usr/local/lib /lib /usr/lib'
@@ -14675,7 +14675,7 @@ darwin* | rhapsody*)
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'
+  shrext_cmds=".dylib"
 
   sys_lib_dlsearch_path_spec='/usr/local/lib /lib /usr/lib'
   ;;
