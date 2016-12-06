require 'formula'

class Awesome < Formula
  url 'http://awesome.naquadah.org/download/awesome-3.4.10.tar.bz2'
  homepage 'http://awesome.naquadah.org/'
  md5 '245087f8065867eff37a2133287d5c03'

  depends_on 'cmake'
  depends_on 'lua'
  depends_on 'imlib2'
  depends_on 'libxdg-basedir'
  depends_on 'startup-notification'
  depends_on 'libev'
  depends_on 'libiconv'

  def caveats; <<-EOS.undent
    If this is your first time installing awesome, you need to configure it:

        mkdir ~/.xinitrc.d
        echo "export USERWM=/usr/local/bin/awesome" > ~/.xinitrc.d/90-awesome.sh
        chmod +x ~/.xinitrc.d/90-awesome.sh
        mkdir -p ~/.config
        ln -s #{HOMEBREW_PREFIX}/etc/xdg/awesome ~/.config/awesome

    Then start X11 which should use awesome as its window manager.
    EOS
  end

  def patches
    DATA
  end

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3fe5a55..50a6d81 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -96,7 +96,7 @@ add_executable(${PROJECT_AWE_NAME}
 
 set_target_properties(${PROJECT_AWE_NAME}
     PROPERTIES
-    LINK_FLAGS -export-dynamic)
+    LINK_FLAGS --export-dynamic)
 
 target_link_libraries(${PROJECT_AWE_NAME}
     ${AWESOME_COMMON_REQUIRED_LDFLAGS}
diff --git a/awesomeConfig.cmake b/awesomeConfig.cmake
index ee75d49..391e779 100644
--- a/awesomeConfig.cmake
+++ b/awesomeConfig.cmake
@@ -164,6 +164,8 @@ endmacro()
 # Check for libev
 a_find_library(LIB_EV ev)
 
+a_find_library(LIB_ICONV iconv)
+
 # Check for backtrace_symbols()
 include(CheckFunctionExists)
 check_function_exists(backtrace_symbols HAS_EXECINFO)
@@ -201,6 +203,7 @@ set(AWESOME_REQUIRED_LDFLAGS
     ${AWESOME_COMMON_REQUIRED_LDFLAGS}
     ${AWESOME_REQUIRED_LDFLAGS}
     ${LIB_EV}
+    ${LIB_ICONV}
     ${LUA_LIBRARIES})
 
 set(AWESOME_REQUIRED_INCLUDE_DIRS
