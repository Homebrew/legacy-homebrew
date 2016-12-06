class Fastflow < Formula
  desc "C++ parallel programming framework"
  homepage "http://calvados.di.unipi.it/"
  url "https://downloads.sourceforge.net/project/mc-fastflow/fastflow-2.0.4.tgz"
  sha256 "4c5eda03b6aeaabda468bacb2085fdaa481ba2412138303ea0f07ce203de1a3e"
  head "http://svn.code.sf.net/p/mc-fastflow/code/"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/raw/05a0256d0eeea8063690fde6a156e14b70ed2280/zmq.hpp"
    sha256 "bf1c5b38911ca10bfd0826574710eb0c68fbd89b6eaa5e137c34dfbf824c080a"
  end

  patch :DATA

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DBUILD_TESTS:BOOL=NO
      -DBUILD_EXAMPLES:BOOL=NO
    ]

    resource("cppzmq").stage include.to_s

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ff/parallel_for.hpp>
      int main() {
        long A[100];
        ff::ParallelFor pf;
        pf.parallel_for(0,100,[&A](const long i) {
          A[i] = i;
        });
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
__END__
--- a/CMakeLists.txt	2015-10-31 10:38:00.000000000 -0300
+++ b/CMakeLists.txt	2015-10-31 10:41:31.000000000 -0300
@@ -139,13 +139,24 @@
     ${FF}/allocator.hpp
     ${FF}/buffer.hpp
     ${FF}/cycle.h
+    ${FF}/dinout.hpp
+    ${FF}/dnode.hpp
+    ${FF}/dynlinkedlist.hpp
     ${FF}/farm.hpp
+    ${FF}/ff_queue.hpp
+    ${FF}/gsearch.hpp
     ${FF}/gt.hpp
+    ${FF}/icl_hash.h
     ${FF}/lb.hpp
+    ${FF}/map.hpp
+    ${FF}/mdf.hpp
     ${FF}/node.hpp
+    ${FF}/parallel_for.hpp
+    ${FF}/partitioners.hpp
     ${FF}/pipeline.hpp
     ${FF}/spin-lock.hpp
     ${FF}/squeue.hpp
+    ${FF}/staticlinkedlist.hpp
     ${FF}/svector.hpp
     ${FF}/sysdep.h
     ${FF}/ubuffer.hpp
