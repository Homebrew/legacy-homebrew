require 'formula'

class Ideviceactivate < Formula
  url 'git://github.com/cfergeau/ideviceactivate.git'
  homepage 'https://github.com/cfergeau/ideviceactivate'
  version '0.1'

  depends_on 'libimobiledevice'
  depends_on 'curl'

  # The project Makefile lists librt and libgthread-2.0 as dependencies and Mac OS X doesn't have these. Luckily they are never actually used in the code, so it's safe to remove them.
  def patches
  DATA
  end


  def install
    system "make"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 376b333..1377097 100755
--- a/src/Makefile
+++ b/src/Makefile
@@ -1,5 +1,5 @@
 CFLAGS := -g -pthread -I/usr/local/include -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include/libxml2
-LDFLAGS := -pthread -L/usr/local/lib -limobiledevice -lplist -lusbmuxd -lgthread-2.0 -lrt -lgnutls -ltasn1 -lxml2 -lglib-2.0 -lcurl
+LDFLAGS := -pthread -L/usr/local/lib -limobiledevice -lplist -lusbmuxd -lgnutls -ltasn1 -lxml2 -lglib-2.0 -lcurl
 
 all:
 	gcc -o ideviceactivate ideviceactivate.c activate.c cache.c util.c $(CFLAGS) $(LDFLAGS)

