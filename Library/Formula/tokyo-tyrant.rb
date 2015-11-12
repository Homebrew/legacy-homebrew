class TokyoTyrant < Formula
  desc "Lightweight database server"
  homepage "http://fallabs.com/tokyotyrant/"
  url "http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz"
  sha256 "42af70fb9f2795d4e05c3e37941ce392a9eaafc991e230c48115370f6d64b88f"
  revision 1

  option "no-lua", "Disable Lua support"

  depends_on "tokyo-cabinet"
  depends_on "lua51" unless build.include? "no-lua"

  unless build.include? "no-lua"
    patch :DATA
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-lua" unless build.include? "no-lua"

    system "./configure", *args
    system "make"
    system "make", "install"
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
