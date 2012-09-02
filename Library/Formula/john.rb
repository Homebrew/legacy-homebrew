require 'formula'

class John < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/g/john-1.7.9.tar.bz2'
  sha1 '8f77bdd42b7cf94ec176f55ea69c4da9b2b8fe3b'

  fails_with :llvm do
    build 2334
  end

  def patches; DATA; end

  def install
    ENV.deparallelize
    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    cd 'src' do
      system "make", "clean", "macosx-x86-#{arch}"
    end

    rm 'README'
    # using mv over bin.install due to problem moving sym links
    mv 'run', bin
    chmod_R 0755, bin
  end
end


__END__
--- a/src/john.c	2010-01-01 22:58:55.000000000 -0500
+++ b/src/john.c	2010-01-01 22:59:11.000000000 -0500
@@ -290,7 +290,7 @@ static void john_init(char *name, int ar
 		cfg_init(CFG_PRIVATE_ALT_NAME, 1);
 #endif
 		cfg_init(CFG_FULL_NAME, 1);
-		cfg_init(CFG_ALT_NAME, 0);
+		cfg_init(CFG_ALT_NAME, 1);
 	}
 
 	status_init(NULL, 1);
