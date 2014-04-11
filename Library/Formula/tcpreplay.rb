require 'formula'

class Tcpreplay < Formula
  homepage 'http://tcpreplay.synfin.net'
  url 'https://downloads.sourceforge.net/project/tcpreplay/tcpreplay/3.4.4/tcpreplay-3.4.4.tar.gz'
  sha1 '9e4cca81cfbfb919f8759e1a27ce1b3b963ff3b8'

  # Hard-code use of dylib instead of so
  patch :DATA

  # Use system strlcpy; fixed upstream
  patch do
    url "https://github.com/synfinatic/tcpreplay/commit/6f45329ba7e6300f07f253032e6feb8a650bea23.diff"
    sha1 "06a8323b7dd8545ea1a629b193b2b1f04535a4a7"
  end

  patch do
    url "https://github.com/synfinatic/tcpreplay/commit/0983f589a21bbd0d248e9b408bdf5aeacb61ce19.diff"
    sha1 "1cb5080a6c032f78b3ac5be28a7e6ac9c4c821da"
  end

  def install
    # Don't attempt to compile strlcpy; fixed upstream
    inreplace "lib/Makefile.in" do |s|
      s.remove_make_var! "libstrl_a_SOURCES"
      s.remove_make_var! "noinst_LIBRARIES"
    end

    inreplace "src/common/Makefile.in" do |s|
      s.gsub! "libcommon_a_LIBADD = ../../lib/libstrl.a", ""
      s.gsub! "libcommon_a_DEPENDENCIES = ../../lib/libstrl.a", ""
    end

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
