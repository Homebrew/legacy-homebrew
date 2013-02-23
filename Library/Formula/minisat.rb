require 'formula'

class Minisat < Formula
  homepage 'http://minisat.se'
  url 'https://github.com/niklasso/minisat/tarball/releases/2.2.0'
  sha1 'dcd4bbb4620db5f49e19222d59318b2c615b4fd1'

  # Fixes compilation on mac; in next upstream release. See:
  # http://groups.google.com/group/minisat/browse_thread/thread/f5b6a180cadbb214
  def patches
    DATA
  end

  def install
    ENV['MROOT'] = Dir.pwd
    Dir.chdir 'simp'
    system "make", "r"
    bin.install 'minisat_release' => 'minisat'
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
