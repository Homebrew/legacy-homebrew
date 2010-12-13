require 'formula'

class John <Formula
  url 'http://www.openwall.com/john/g/john-1.7.3.4.tar.bz2'
  homepage 'http://www.openwall.com/john/'
  md5 '2f2310c49961c3edea6f92b8dcd45ff4'

  def patches
    { :p0 => DATA }
  end

  def install
    ENV.deparallelize
    fails_with_llvm
    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    Dir.chdir 'src' do
      system "make clean macosx-x86-#{arch}"
    end

    rm 'README'
    # using mv over bin.install due to problem moving sym links
    mv 'run', bin
    chmod_R 0755, bin
  end
end


__END__
--- src/john.c.orig	2010-01-01 22:58:55.000000000 -0500
+++ src/john.c	2010-01-01 22:59:11.000000000 -0500
@@ -249,7 +249,7 @@ static void john_init(char *name, int ar
 		cfg_init(CFG_PRIVATE_ALT_NAME, 1);
 #endif
 		cfg_init(CFG_FULL_NAME, 1);
-		cfg_init(CFG_ALT_NAME, 0);
+		cfg_init(CFG_ALT_NAME, 1);
 	}
 
 	status_init(NULL, 1);
