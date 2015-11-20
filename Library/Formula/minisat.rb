class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"
  url "https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz"
  sha256 "3ed44da999744c0a1be269df23c3ed8731cdb83c44a4f3aa29b3d6859bb2a4da"

  bottle do
    cellar :any
    sha256 "c2537e0e2d6428e87f1ed7f502fd0fa86f3c7ee2cee58b27817f6fdd20b3a66b" => :el_capitan
    sha256 "c261e92ecf583b97b78f3e4924324d8804387b61ed3474d2d3284120e07355d6" => :yosemite
    sha256 "ce8794df1ba908e6b062fe55f2db55e9398b3c23e881da7e3cb118b645b938f0" => :mavericks
  end

  # Fix some declaration errors; see:
  # https://groups.google.com/forum/#!topic/minisat/9bahgMrbshQ
  patch :DATA

  fails_with :clang do
    cause "error: friend declaration specifying a default argument must be a definition"
  end

  def install
    ENV["MROOT"] = buildpath
    system "make", "-C", "simp", "r"
    bin.install "simp/minisat_release" => "minisat"
  end
end

__END__
diff --git a/utils/System.cc b/utils/System.cc
index a7cf53f..feeaf3c 100644
--- a/utils/System.cc
+++ b/utils/System.cc
@@ -78,16 +78,17 @@ double Minisat::memUsed(void) {
     struct rusage ru;
     getrusage(RUSAGE_SELF, &ru);
     return (double)ru.ru_maxrss / 1024; }
-double MiniSat::memUsedPeak(void) { return memUsed(); }
+double Minisat::memUsedPeak(void) { return memUsed(); }
 
 
 #elif defined(__APPLE__)
 #include <malloc/malloc.h>
 
-double Minisat::memUsed(void) {
+double Minisat::memUsed() {
     malloc_statistics_t t;
     malloc_zone_statistics(NULL, &t);
     return (double)t.max_size_in_use / (1024*1024); }
+double Minisat::memUsedPeak() { return memUsed(); }
 
 #else
 double Minisat::memUsed() { 
