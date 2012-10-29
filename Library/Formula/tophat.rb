require 'formula'

class Tophat < Formula
  homepage 'http://tophat.cbcb.umd.edu/'
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-2.0.6.tar.gz'
  sha1 'd1c19cdccb5ddf74b8cb604a0ed1e5d33a25aae9'

  depends_on 'samtools'
  depends_on 'boost'

  # Variable length arrays using non-POD element types. Initialize with length=1
  # Reported upstream via email to tophat-cufflinks@gmail.com on 28OCT2012
  def patches; DATA; end

  def install
    # This can only build serially, otherwise it errors with no make target.
    ENV.deparallelize

    # Must add this to fix missing boost symbols. Autoconf doesn't include it.
    ENV.append 'LDFLAGS', '-lboost_system-mt'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/src/segment_juncs.cpp	2012-10-17 09:29:03.000000000 -0700
+++ b/src/segment_juncs.cpp	2012-10-27 22:24:44.000000000 -0700
@@ -4854,15 +4854,15 @@
       exit(0);
     }
   
-  std::set<Junction, skip_count_lt> vseg_juncs[num_threads];
+  std::set<Junction, skip_count_lt> vseg_juncs[1];
   std::set<Junction, skip_count_lt> cov_juncs;
   std::set<Junction, skip_count_lt> butterfly_juncs;
   
   std::set<Junction> juncs;
   
-  std::set<Deletion> vdeletions[num_threads];
-  std::set<Insertion> vinsertions[num_threads];
-  FusionSimpleSet vfusions[num_threads];
+  std::set<Deletion> vdeletions[1];
+  std::set<Insertion> vinsertions[1];
+  FusionSimpleSet vfusions[1];
   
   RefSequenceTable rt(sam_header, true);
   
--- a/src/tophat_reports.cpp	2012-10-18 10:43:09.000000000 -0700
+++ b/src/tophat_reports.cpp	2012-10-27 22:39:31.000000000 -0700
@@ -2290,11 +2290,11 @@
 	num_threads = 1;
     }
 
-  JunctionSet vjunctions[num_threads];
-  InsertionSet vinsertions[num_threads];
-  DeletionSet vdeletions[num_threads];
-  FusionSet vfusions[num_threads];
-  Coverage vcoverages[num_threads];
+  JunctionSet vjunctions[1];
+  InsertionSet vinsertions[1];
+  DeletionSet vdeletions[1];
+  FusionSet vfusions[1];
+  Coverage vcoverages[1];
   
   vector<boost::thread*> threads;
   for (int i = 0; i < num_threads; ++i)
@@ -2420,10 +2420,10 @@
     fprintf(stderr, "Warning: %lu small overhang junctions!\n", (long unsigned int)small_overhangs);
   */
 
-  JunctionSet vfinal_junctions[num_threads];
-  InsertionSet vfinal_insertions[num_threads];
-  DeletionSet vfinal_deletions[num_threads];
-  FusionSet vfinal_fusions[num_threads];
+  JunctionSet vfinal_junctions[1];
+  InsertionSet vfinal_insertions[1];
+  DeletionSet vfinal_deletions[1];
+  FusionSet vfinal_fusions[1];
 
   for (int i = 0; i < num_threads; ++i)
     {
