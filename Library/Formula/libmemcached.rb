require "formula"

class Libmemcached < Formula
  homepage "http://libmemcached.org"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha1 "8be06b5b95adbc0a7cb0f232e237b648caf783e1"

  option "with-sasl", "Build with sasl support"

  if build.with? "sasl"
    depends_on "memcached" => "enable-sasl"
  else
    depends_on "memcached"
  end

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    args = ["--prefix=#{prefix}"]

    if build.with? "sasl"
      args << "--with-memcached-sasl=#{Formula.factory("memcached").bin}/memcached"
    end

    system "./configure", *args
    system "make install"
  end

  def patches
    DATA
  end

end

__END__
diff --git a/clients/memflush.cc b/clients/memflush.cc
index 8bd0dbf..cdba743 100644
--- a/clients/memflush.cc
+++ b/clients/memflush.cc
@@ -39,7 +39,7 @@ int main(int argc, char *argv[])
 {
   options_parse(argc, argv);
 
-  if (opt_servers == false)
+  if (*opt_servers != NULL)
   {
     char *temp;
 
@@ -48,7 +48,7 @@ int main(int argc, char *argv[])
       opt_servers= strdup(temp);
     }
 
-    if (opt_servers == false)
+    if (*opt_servers != NULL)
     {
       std::cerr << "No Servers provided" << std::endl;
       exit(EXIT_FAILURE);
