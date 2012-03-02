require 'formula'

# homebrew only untars if gz or bzip :(
class TarDownloadStrategy < CurlDownloadStrategy
  def stage
      safe_system '/usr/bin/tar', 'xf', @tarball_path
  end
end

class Iozone < Formula
  homepage 'http://www.iozone.org/'
  url 'http://www.iozone.org/src/current/iozone3_398.tar',
    :using => TarDownloadStrategy
  md5 'ac6e7534c77602a1c886f3bb8679ad2a'

  def patches
    # adds O_DIRECT support when using -I flag
    DATA
  end

  def install
    system "make -C iozone3_398/src/current macosx"
    bin.install 'iozone3_398/src/current/iozone'
    man1.install 'iozone3_398/docs/iozone.1'
  end

  def test
    `iozone -I -s 16M | grep -c O_DIRECT`.chomp == '1'
  end
end

__END__
--- a/iozone3_398/src/current/iozone.c      2011-12-16 09:17:05.000000000 -0800
+++ b/iozone3_398/src/current/iozone.c      2012-02-28 16:57:58.000000000 -0800
@@ -1810,7 +1810,7 @@
 			break;
 #endif
 #if ! defined(DONT_HAVE_O_DIRECT)
-#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris)
+#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris) || defined(macosx)
 			direct_flag++;
 			sprintf(splash[splash_line++],"\tO_DIRECT feature enabled\n");
 			break;
