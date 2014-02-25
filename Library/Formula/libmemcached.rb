require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz'
  sha1 '8be06b5b95adbc0a7cb0f232e237b648caf783e1'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    DATA
  end

end

__END__
--- a/clients/memflush.cc
+++ b/clients/memflush.cc
@@ -39,7 +39,7 @@
 {
   options_parse(argc, argv);
 
-  if (opt_servers == false)
+  if (*opt_servers != NULL)
   {
     char *temp;
 
@@ -48,7 +48,7 @@
       opt_servers= strdup(temp);
     }
 
-    if (opt_servers == false)
+    if (*opt_servers != NULL)
     {
       std::cerr << "No Servers provided" << std::endl;
       exit(EXIT_FAILURE);
