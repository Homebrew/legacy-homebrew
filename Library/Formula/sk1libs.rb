require 'formula'

class Sk1libs < Formula
  homepage 'http://sk1project.org/modules.php?name=products&product=sk1&op=download'
  url 'http://sk1project.org/dc.php?target=sk1libs-0.9.1.tar.gz'
  sha1 'dd948558128bb6547b1f277087bf3066104912da'

  depends_on 'lcms2'

  # educate sk1libs about Mac OS X fonts directories
  def patches; DATA; end

  def install
    ENV.x11

    # Explicitly set the arch in CFLAGS so it will build against system Python
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV.append_to_cflags archs.as_arch_flags

    # for some reason it doesn't look at X11 freetype headers
    ENV.append_to_cflags "-I /usr/X11/include/freetype2/"

    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end
end

__END__
diff --git a/src/utils/fs.py b/src/utils/fs.py
index 2c90fab..0817573 100644
--- a/src/utils/fs.py
+++ b/src/utils/fs.py
@@ -220,8 +220,8 @@ def get_system_fontdirs():
 			finally:
 				_winreg.CloseKey( k )
 	if system.get_os_family()==system.MACOSX:
-		#FIXME: It's a stub. The paths should be more exact.
-		return ['/',]
+		return ['/Library/Fonts',
+ 			os.path.join(gethome(), 'Library/Fonts')]
 
 
 DIRECTORY_OBJECT=0
@@ -311,4 +311,4 @@ def _test():
 if __name__ == '__main__':
     _test()
 	
-	
\ No newline at end of file
+	

