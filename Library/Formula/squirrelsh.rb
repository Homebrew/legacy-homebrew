require 'formula'

class Squirrelsh < Formula
  url 'http://sourceforge.net/projects/squirrelsh/files/Squirrel%20Shell/1.2.6/squirrelsh-1.2.6-src.tar.bz2'
  homepage 'http://squirrelsh.sourceforge.net/'
  md5 '93eec3faad3390f78c12d0f7a5812021'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'squirrel'

  def patches
    DATA
  end

  def install
    system "LFLAGS=\"-Wl\" ./configure --with-pcre=system --with-squirrel=system --prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 815719b..ab156e0 100755
--- a/configure
+++ b/configure
@@ -758,11 +758,6 @@ macosx)
		echo "WARNING: Forcing use of static libraries"
		with_libraries="static"
	fi
-
-	if [ "$with_pcre" != "local" ]; then
-		echo "WARNING: Forcing use of local PCRE library"
-		with_pcre="local"
-	fi
	;;
 *)
	;;
@@ -955,7 +950,6 @@ int main ()
	if (!vm)
		return 1;

-	sq_setmaxparams(vm, 1);
	sq_close(vm);
	return 0;
 }
