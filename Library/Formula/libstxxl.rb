require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/stxxl/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  sha1 '5fba2bb26b919a07e966b2f69ae29aa671892a7d'

  # issue has been rectified in upstream and future 1.4.0 release
  patch :DATA if MacOS.version >= :mavericks

  def install
    ENV['COMPILER'] = ENV.cxx
    if MacOS.version >= :mavericks
      inreplace 'make.settings.gnu' do |s|
        s.gsub! /USE_MACOSX.*no/, 'USE_MACOSX ?= yes#'
        s.gsub! /#STXXL_SPECIFIC\s*\+=.*$/, 'STXXL_SPECIFIC += -std=c++0x'
      end
    end
    system "make", "config_gnu", "USE_MACOSX=yes"
    system "make", "library_g++", "USE_MACOSX=yes"

    prefix.install 'include'
    lib.install 'lib/libstxxl.a'
  end
end

__END__
Index: utils/mlock.cpp
===================================================================
--- stxxl-1.3.1/utils/mlock.cpp (revision 3229)
+++ stxxl-1.3.1/utils/mlock.cpp (working copy)
@@ -18,6 +18,9 @@
 #include <iostream>
 #include <sys/mman.h>

+#include <chrono>
+#include <thread>
+
 int main(int argc, char ** argv)
 {
     if (argc == 2) {
@@ -28,8 +31,9 @@
                 c[i] = 42;
             if (mlock(c, M) == 0) {
                 std::cout << "mlock(, " << M << ") successful, press Ctrl-C to finish" << std::endl;
+                std::chrono::seconds duration(86400);
                 while (1)
-                    sleep(86400);
+                    std::this_thread::sleep_for(duration);
             } else {
                 std::cerr << "mlock(, " << M << ") failed!" << std::endl;
                 return 1;
