require 'formula'

class Msdl < Formula
  homepage 'http://msdl.sourceforge.net'
  url 'http://downloads.sourceforge.net/msdl/msdl-1.2.7-r2.tar.gz'
  version '1.2.7-r2'
  sha1 'd30a637fc8be4ea80ddd373e428542bef15297fb'

  # Fixes linker error under clang; apparently reported upstream:
  # https://github.com/mxcl/homebrew/pull/13907
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/url.c b/src/url.c
index 81783c7..356883a 100644
--- a/src/url.c
+++ b/src/url.c
@@ -266,7 +266,7 @@ void url_unescape_string(char *dst,char *src)
 /*
  * return true if 'c' is valid url character
  */
-inline int is_url_valid_char(int c)
+int is_url_valid_char(int c)
 {
     return (isalpha(c) ||
	    isdigit(c) ||
