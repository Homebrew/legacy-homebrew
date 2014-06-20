require 'formula'

class Iozone < Formula
  homepage 'http://www.iozone.org/'
  url 'http://www.iozone.org/src/current/iozone3_413.tar'
  sha1 '397c2aae67f74dc9d189912b2e72ca594b790101'

  # Patch by @nijotz, adds O_DIRECT support when using -I flag.
  # See: https://github.com/Homebrew/homebrew/pull/10585
  patch :DATA

  def install
    cd 'src/current' do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install 'iozone'
      (share/'iozone').install 'Generate_Graphs', 'client_list', 'gengnuplot.sh', 'gnu3d.dem', 'gnuplot.dem', 'gnuplotps.dem', 'iozone_visualizer.pl', 'report.pl'
    end
    man1.install 'docs/iozone.1'
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/iozone", "-I", "-s", "16M") do |_, stdout, _|
      assert_match /File size set to 16384 KB/, stdout.read
    end
  end
end

__END__
--- a/src/current/iozone.c      2011-12-16 09:17:05.000000000 -0800
+++ b/src/current/iozone.c      2012-02-28 16:57:58.000000000 -0800
@@ -1820,7 +1810,7 @@
 			break;
 #endif
 #if ! defined(DONT_HAVE_O_DIRECT)
-#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris)
+#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris) || defined(macosx)
 			direct_flag++;
 			sprintf(splash[splash_line++],"\tO_DIRECT feature enabled\n");
 			break;
