require 'formula'

class OpengrmThrax < Formula
  url 'http://openfst.cs.nyu.edu/twiki/pub/GRM/ThraxDownload/thrax-1.1.0.tar.gz'
  homepage 'http://openfst.cs.nyu.edu/twiki/bin/view/GRM/Thrax'
  sha1 'b2e0bee89e40098bbb94d119aac8bf518339b7d3'

  depends_on 'openfst'

  def patches
    # bug has been reported upstream and will be fixed in the next release;
    # see http://openfst.cs.nyu.edu/twiki/bin/view/Forum/GrmThraxForum
    DATA
  end 

  def install
    if MacOS.version > :mountain_lion
      ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/c++/4.2.1"
      ENV.append 'LIBS', "#{MacOS.sdk_path}/usr/lib/libstdc++.dylib"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -Naur thrax-1.1.0-orig/src/include/thrax/compat/utils.h thrax-1.1.0/src/include/thrax/compat/utils.h 
--- thrax-1.1.0-orig/src/include/thrax/compat/utils.h   2013-11-06 13:59:14.000000000 -0800
+++ thrax-1.1.0/src/include/thrax/compat/utils.h    2013-11-06 14:01:04.000000000 -0800
@@ -116,7 +116,7 @@
  public:
   explicit InputBuffer(File* fp) : fp_(fp) { }
   ~InputBuffer() { delete fp_; }
-  char buf[];
+  /* char buf[]; */
   bool ReadLine(string* line) {
     line->clear();
     fp_->stream()->getline(buf_, MAXLINE);
