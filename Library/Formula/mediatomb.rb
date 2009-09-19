require 'brewkit'

class Mediatomb <Formula
  @url='http://downloads.sourceforge.net/mediatomb/mediatomb-0.11.0.tar.gz'
  @homepage='http://mediatomb.cc'
  @md5='661f08933830d920de21436fe122fb15'
  
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

__END__
diff -Naur mediatomb-0.11.0/src/url.cc mediatomb-0.11.0/src/url-patched.cc 
--- mediatomb-0.11.0/src/url.cc	2009-09-19 02:37:12.000000000 +0200
+++ mediatomb-0.11.0/src/url-patched.cc	2009-09-19 02:37:21.000000000 +0200
@@ -75,7 +75,7 @@
 
     if (only_header)
     {
-        curl_easy_setopt(curl_handle, CURLOPT_NOBODY);
+        curl_easy_setopt(curl_handle, CURLOPT_NOBODY, 1);
         curl_easy_setopt(curl_handle, CURLOPT_HEADERFUNCTION, URL::dl);
         curl_easy_setopt(curl_handle, CURLOPT_HEADERDATA, 
                          (void *)buffer.getPtr());
