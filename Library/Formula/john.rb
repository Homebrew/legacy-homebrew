require 'formula'

class John < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/g/john-1.7.9-jumbo-5.tar.bz2'
  md5 'e7a9912e6011399d4df35013d0440c67'
  version '1.7.9'

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
--- a/src/john.c	2012-05-01 19:59:09.000000000 +0200
+++ b/src/john.c	2012-05-01 19:59:31.000000000 +0200
@@ -436,7 +436,7 @@ static void john_init(char *name, int ar
 			cfg_init(CFG_PRIVATE_ALT_NAME, 1);
 #endif
 			cfg_init(CFG_FULL_NAME, 1);
-			cfg_init(CFG_ALT_NAME, 0);
+			cfg_init(CFG_ALT_NAME, 1);
 		}
 	}
 
