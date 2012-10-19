require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  sha1 'd13edc1477d0ab32cafe7d3c1f3a23ae1c0a5c54'

  head 'http://elinks.cz/elinks.git'

  devel do
    url 'http://elinks.cz/download/elinks-0.12pre5.tar.bz2'
    version '0.12pre5'
    sha1 '15fb38fa938a0eec9d5f22fdd538a6785e2854af'
  end

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  fails_with :llvm do
    build 2326
  end

  # enables 256 colors, per the manual
  def patches
    DATA
  end

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if build.head?
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

