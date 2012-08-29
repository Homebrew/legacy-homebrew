require 'formula'

class Iozone < Formula
  homepage 'http://www.iozone.org/'
  url 'http://www.iozone.org/src/current/iozone3_408.tar'
  md5 'ff3bc9a075db68b028e6cd5a833353d8'

  # Patch by @nijotz, adds O_DIRECT support when using -I flag.
  # See: https://github.com/mxcl/homebrew/pull/10585
  def patches
    DATA
  end

  def install
    system "make -C src/current macosx"
    bin.install 'src/current/iozone'
    man1.install 'docs/iozone.1'
  end

  def test
    `#{bin}/iozone -I -s 16M | grep -c O_DIRECT`.chomp == '1'
  end
end

__END__
--- a/src/current/iozone.c      2011-12-16 09:17:05.000000000 -0800
+++ b/src/current/iozone.c      2012-02-28 16:57:58.000000000 -0800
@@ -1810,7 +1810,7 @@
 			break;
 #endif
 #if ! defined(DONT_HAVE_O_DIRECT)
-#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris)
+#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris) || defined(macosx)
 			direct_flag++;
 			sprintf(splash[splash_line++],"\tO_DIRECT feature enabled\n");
 			break;
