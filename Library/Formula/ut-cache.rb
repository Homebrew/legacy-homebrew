require 'formula'

class UtCache <Formula
  head 'git://github.com/tanj/Unreal-Tournament-Cache.git'
  homepage 'https://github.com/tanj/Unreal-Tournament-Cache'

  def patches
    DATA
  end

  def install
    system "curl -o getdelim.c https://gist.github.com/raw/278167/26eae93b355d443693c1e8922a328d4a61b4a176/getdelim.c"
    bin.mkpath
    ENV['HOME'] = prefix
    system "make"
    system "make install"
  end
end

__END__
diff --git a/ut-cache.c b/ut-cache.c
index 70d61ea..9fd1621 100644
--- a/ut-cache.c
+++ b/ut-cache.c
@@ -7,6 +7,7 @@
    the proper directory */
 
 #include "ut-cache.h"
+#include "getdelim.c"
 
 void usage(const char *err)
 {
