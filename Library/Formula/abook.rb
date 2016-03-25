class Abook < Formula
  desc "Address book with mutt support"
  homepage "http://abook.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/abook/abook/0.5.6/abook-0.5.6.tar.gz"
  sha256 "0646f6311a94ad3341812a4de12a5a940a7a44d5cb6e9da5b0930aae9f44756e"
  head "git://git.code.sf.net/p/abook/git"

  bottle do
    sha256 "0c016cb533c530997b9899cdd321627b45e58e35267bdcae99ff31309bc73a44" => :el_capitan
    sha256 "b04026d64ca791972c1d0f1092eebbccfc2ea2d051072ac15131653a41ddb926" => :yosemite
    sha256 "e2ba9afe35d0ea1fd71df27fd930b4f5caaee0075301734f04892b651fec6f37" => :mavericks
  end

  devel do
    url "http://abook.sourceforge.net/devel/abook-0.6.0pre2.tar.gz"
    sha256 "59d444504109dd96816e003b3023175981ae179af479349c34fa70bc12f6d385"
    version "0.6.0pre2"

    # Remove `inline` from function implementation for clang compatibility
    patch :DATA
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end

__END__
diff --git a/database.c b/database.c
index 7c47ab6..53bdb9f 100644
--- a/database.c
+++ b/database.c
@@ -762,7 +762,7 @@ item_duplicate(list_item dest, list_item src)
  */
 
 /* quick lookup by "standard" field number */
-inline int
+int
 field_id(int i)
 {
 	assert((i >= 0) && (i < ITEM_FIELDS));
