require "formula"

class Libmemcached < Formula
  homepage "http://libmemcached.org"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha1 "8be06b5b95adbc0a7cb0f232e237b648caf783e1"

  bottle do
    cellar :any
    sha1 "abc6b08082ef18c8abb0df901063e88ee21fa82e" => :mavericks
    sha1 "a4da2082b38e15cd86dffd3f3b3c5b691dee1f90" => :mountain_lion
    sha1 "5029f4a7f05dd5f727b17617e49b424940c3def0" => :lion
  end

  option "with-sasl", "Build with sasl support"

  if build.with? "sasl"
    depends_on "memcached" => "enable-sasl"
  else
    depends_on "memcached"
  end

  # https://bugs.launchpad.net/libmemcached/+bug/1284765
  patch :DATA

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    args = ["--prefix=#{prefix}"]

    if build.with? "sasl"
      args << "--with-memcached-sasl=#{Formula["memcached"].bin}/memcached"
    end

    system "./configure", *args
    system "make install"
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
diff --git a/libmemcached-1.0/memcached.h b/libmemcached-1.0/memcached.h
index bc16e73..dcee395 100644
--- a/libmemcached-1.0/memcached.h
+++ b/libmemcached-1.0/memcached.h
@@ -43,7 +43,11 @@
 #endif

 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
 #  include <cinttypes>
+#else
+#  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #else
