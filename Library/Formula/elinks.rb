require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  md5 'fcd087a6d2415cd4c6fd1db53dceb646'

  head 'http://elinks.cz/elinks.git', :using => :git

  fails_with_llvm :build => 2326

  # enables 256 colors, per the manual
  def patches
    DATA
  end

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey"
    system "make install"
  end
end

__END__
diff --git a/features.conf b/features.conf
index 1c0095c..7ee8b0d 100644
--- a/features.conf
+++ b/features.conf
@@ -501,7 +501,7 @@ CONFIG_88_COLORS=no
 #
 # Default: disabled
 
-CONFIG_256_COLORS=no
+CONFIG_256_COLORS=yes
 
 
 ### Ex-mode Interface

