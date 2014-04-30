require "formula"

class OpengrmThrax < Formula
  homepage "http://openfst.cs.nyu.edu/twiki/bin/view/GRM/Thrax"
  url "http://openfst.cs.nyu.edu/twiki/pub/GRM/ThraxDownload/thrax-1.1.0.tar.gz"
  sha1 "b2e0bee89e40098bbb94d119aac8bf518339b7d3"

  depends_on "openfst"

  resource "export2" do
    url "http://openfst.cs.nyu.edu/twiki/pub/Contrib/ThraxContrib/export2.tgz"
    sha1 "3de5811cbb72933f62ccceb578697e9904256fac"
  end

  def patches
    # bug has been reported upstream and will be fixed in the next release;
    # see http://openfst.cs.nyu.edu/twiki/bin/view/Forum/GrmThraxForum
    DATA
  end

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end

  test do
    resource("export2").stage do
        # an example from CSLU class on text normalization
        Dir.chdir("grammars/number_names") do
            system "thraxmakedep", "numbers_en_us.grm"
            system "make"
            system "thraxrandom-generator",
                   "--far=numbers_en_us.far",
                   "--rule=CARDINAL_NUMBER_NAME"
        end
    end
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
