require 'formula'

class TokyoTyrant < Formula
  homepage 'http://fallabs.com/tokyotyrant/'
  url 'http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz'
  sha1 '060ac946a9ac902c1d244ffafd444f0e5840c0ce'
  revision 2

  option "no-lua", "Disable Lua support"

  depends_on 'tokyo-cabinet'
  depends_on 'lua51' unless build.include? "no-lua"

  unless build.include? "no-lua"
    patch :DATA
  end

  patch :p0 do
    url 'https://gist.githubusercontent.com/actsasflinn/348633/raw/32561ebf6487650ce86d0184f0ca35bb8110d04c/macosx_snow_leopard_socket_fix.patch'
    sha1 '2b73fe52c37cd41b8e13112c0bc083bce8ae3c9e'
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-lua" unless build.include? "no-lua"

    system "./configure", *args
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index cd249dc..6e12141 100755
--- a/configure
+++ b/configure
@@ -2153,17 +2153,16 @@ fi
 if test "$enable_lua" = "yes"
 then
   enables="$enables (lua)"
-  luaver=`lua -e 'v = string.gsub(_VERSION, ".* ", ""); print(v)'`
-  MYCPPFLAGS="$MYCPPFLAGS -I/usr/include/lua$luaver -I/usr/local/include/lua$luaver"
-  MYCPPFLAGS="$MYCPPFLAGS -I/usr/include/lua -I/usr/local/include/lua -D_MYLUA"
-  MYLDFLAGS="$MYLDFLAGS -L/usr/include/lua$luaver -L/usr/local/include/lua$luaver"
-  MYLDFLAGS="$MYLDFLAGS -L/usr/include/lua -L/usr/local/include/lua"
-  CPATH="$CPATH:/usr/include/lua$luaver:/usr/local/include/lua$luaver"
-  CPATH="$CPATH:/usr/include/lua:/usr/local/include/lua"
-  LIBRARY_PATH="$LIBRARY_PATH:/usr/lib/lua$luaver:/usr/local/lib/lua$luaver"
-  LIBRARY_PATH="$LIBRARY_PATH:/usr/lib/lua:/usr/local/lib/lua"
-  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/include/lua$luaver:/usr/local/include/lua$luaver"
-  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/include/lua:/usr/local/include/lua"
+  MYCPPFLAGS="$MYCPPFLAGS -I/usr/include/lua -I/usr/local/include/lua5.1"
+  MYCPPFLAGS="$MYCPPFLAGS -I/usr/include/lua -I/usr/local/include/lua5.1"
+  MYLDFLAGS="$MYLDFLAGS -L/usr/include/lua -L/usr/local/include/lua5.1"
+  MYLDFLAGS="$MYLDFLAGS -L/usr/include/lua -L/usr/local/include/lua5.1"
+  CPATH="$CPATH:/usr/include/lua:/usr/local/include/lua5.1"
+  CPATH="$CPATH:/usr/include/lua:/usr/local/include/lua5.1"
+  LIBRARY_PATH="$LIBRARY_PATH:/usr/lib/lua:/usr/local/lib/lua5.1"
+  LIBRARY_PATH="$LIBRARY_PATH:/usr/lib/lua:/usr/local/lib/lua5.1"
+  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/include/lua:/usr/local/include/lua5.1"
+  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/include/lua:/usr/local/include/lua5.1"
 fi
