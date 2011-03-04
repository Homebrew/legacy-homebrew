require 'formula'

class Most <Formula
  url 'ftp://space.mit.edu/pub/davis/most/most-5.0.0a.tar.bz2'
  homepage 'http://www.jedsoft.org/most/'
  md5 '4c42abfc8d3ace1b0e0062ea021a5917'

  depends_on 's-lang'

  def patches; DATA end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end


# most looks in a few set directories for slang, so at least add our prefix
__END__
diff --git a/configure b/configure
index f24b2f1..9ac109c 100755
--- a/configure
+++ b/configure
@@ -9936,13 +9936,8 @@ echo "$as_me: error: --with-slanginc requres a value" >&2;}
             $jd_prefix_incdir \
             /usr/local/slang/include \
             /usr/local/include/slang \
-  	  /usr/local/include \
-  	  /usr/include/slang \
-  	  /usr/slang/include \
-  	  /usr/include \
-  	  /opt/include/slang \
-  	  /opt/slang/include \
-  	  /opt/include"
+	  /usr/local/include \
+	  `brew --prefix`/include"
 
        for X in $lib_include_dirs
        do
@@ -9965,12 +9960,7 @@ echo "$as_me: error: --with-slanginc requres a value" >&2;}
             /usr/local/lib \
             /usr/local/lib/slang \
             /usr/local/slang/lib \
-  	  /usr/lib \
-  	  /usr/lib/slang \
-  	  /usr/slang/lib \
-  	  /opt/lib \
-  	  /opt/lib/slang \
-  	  /opt/slang/lib"
+	  `brew --prefix`/lib"
 
        case "$host_os" in
          *darwin* )
