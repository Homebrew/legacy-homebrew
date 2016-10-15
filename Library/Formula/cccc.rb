class Cccc < Formula
  desc "C and C++ Code Counter"
  homepage "http://sourceforge.net/projects/cccc/"
  url "https://downloads.sourceforge.net/project/cccc/cccc/3.1.4/cccc-3.1.4.tar.gz"
  sha256 "27b3eca9a83a66799332363a80cc4bcd6db9869eddbda1a59a25cdace3ff4dbf"
  patch :DATA

  def install
    # "make cccc" will fail if parallelized.
    ENV.deparallelize

    # these targets have dependencies, but nothing mentioned explicitly in makefile.
    system "make", "pccts"
    system "make", "cccc"
    system "make", "test"
    system "make", "install", "INSTDIR=#{bin}"
  end

  test do
    system "which", "cccc"
  end
end
__END__
diff --git a/cccc/cccc_tbl.cc b/cccc/cccc_tbl.cc
index df98e2b..59f2572 100644
--- a/cccc/cccc_tbl.cc
+++ b/cccc/cccc_tbl.cc
@@ -96,7 +96,7 @@ bool CCCC_Table<T>::remove(T* old_item_ptr)
   typename map_t::iterator value_iterator=map_t::find(old_item_ptr->key());
   if(value_iterator!=map_t::end())
     {
-      erase(value_iterator);
+      map_t::erase(value_iterator);
       retval=true;
     }
   return retval;
diff --git a/makefile b/makefile
index 23ad004..2cca469 100644
--- a/makefile
+++ b/makefile
@@ -20,5 +20,5 @@ test :
 	cd test ; make -f posix.mak
 
 install : 
-	cd install ; su root -c "make -f install.mak" 
+	cd install ; make -f install.mak
 
