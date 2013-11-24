require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.4.2.tar.gz'
  sha1 '40eae61e5681d4c4b38068c4075854c0a91182b9'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost'

  # fix building with clang, upstream:
  # http://git.indexdata.com/?p=metaproxy.git;a=commitdiff;h=97a7133fc8325a08560a0326f80459ec31f516f6
  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/filter_sort.cpp b/src/filter_sort.cpp
index e36e8cd..d6a1993 100644 (file)
--- a/src/filter_sort.cpp
+++ b/src/filter_sort.cpp
@@ -70,7 +70,7 @@ namespace metaproxy_1 {
             Record(Z_NamePlusRecord *n, const char *namespaces,
                    const char *expr, bool debug);
             ~Record();
-            bool operator < (const Record &rhs);
+            bool operator < (const Record &rhs) const;
         };
         class Sort::RecordList : boost::noncopyable {
             Odr_oid *syntax;
@@ -286,7 +286,7 @@ yf::Sort::Record::~Record()
 {
 }

-bool yf::Sort::Record::operator < (const Record &rhs)
+bool yf::Sort::Record::operator < (const Record &rhs) const
 {
     if (strcmp(this->score.c_str(), rhs.score.c_str()) < 0)
         return true;
