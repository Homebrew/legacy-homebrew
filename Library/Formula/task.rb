class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.0.tar.gz"
  sha256 "4d8e67415a6993108c11b8eeef99b76a991af11b22874adbb7ae367e09334636"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.1", :shallow => false

  bottle do
    revision 2
    sha256 "fc6d7d516179dbf8d16768e8d003017c7ae4e28de6e01fb72231f54d0ac91eb3" => :el_capitan
    sha256 "6fb193925ef9ac04569d715062fc6f650ff5575a873ad73d45abbabca40d2bc5" => :yosemite
    sha256 "91fae7d81bb7befc6d1637ab72b928ee753dd073f0d61aada6f5f9f959a6c04f" => :mavericks
  end

  option "without-gnutls", "Don't use gnutls; disables sync support"

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended

  needs :cxx11

  # Fixes the following issues:
  # https://bug.tasktools.org/browse/TW-1748 - libc++ used unconditionally on OS X
  # https://bug.tasktools.org/browse/TW-1749 - PATH_MAX not defined on some OS Xs
  # https://bug.tasktools.org/browse/TW-1750 - REG_ENHANCED flag not supported on all OS Xs
  patch :DATA

  def install
    args = std_cmake_args
    args << "-DENABLE_SYNC=OFF" if build.without? "gnutls"
    system "cmake", ".", *args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5558f6b..f56fe45 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -43,11 +43,14 @@ else (_HAS_CXX11)
  message (FATAL_ERROR "C++11 support missing. Try upgrading your C++ compiler. If you have a good reason for using an outdated compiler, please let us know at support@taskwarrior.org.")
 endif (_HAS_CXX11)

+if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
+  set (_CXX11_FLAGS "${_CXX11_FLAGS} -stdlib=libc++")
+endif (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
+
 if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
   set (LINUX true)
 elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
   set (DARWIN true)
-  set (_CXX11_FLAGS "${_CXX11_FLAGS} -stdlib=libc++")
 elseif (${CMAKE_SYSTEM_NAME} MATCHES "kFreeBSD")
   set (KFREEBSD true)
 elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
diff --git a/src/FS.cpp b/src/FS.cpp
index d73dd87..2f89873 100644
--- a/src/FS.cpp
+++ b/src/FS.cpp
@@ -46,6 +46,10 @@
 #include <limits.h>
 #endif

+#if defined __APPLE__
+#include <sys/syslimits.h>
+#endif
+
 // Fixes build with musl libc.
 #ifndef GLOB_TILDE
 #define GLOB_TILDE 0
diff --git a/src/RX.cpp b/src/RX.cpp
index 4f0ebe9..b5e1efa 100644
--- a/src/RX.cpp
+++ b/src/RX.cpp
@@ -85,7 +85,7 @@ void RX::compile ()

     int result;
     if ((result = regcomp (&_regex, _pattern.c_str (),
-#ifdef DARWIN
+#if defined REG_ENHANCED
                            REG_ENHANCED | REG_EXTENDED | REG_NEWLINE |
 #else
                            REG_EXTENDED | REG_NEWLINE |
