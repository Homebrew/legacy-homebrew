require "formula"

class Iozone < Formula
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_428.tar"
  sha1 "0238f938d35eff5371ebd22a98769d8b8bfc00d7"

  # Patch by @nijotz, adds O_DIRECT support when using -I flag.
  # See: https://github.com/Homebrew/homebrew/pull/10585
  patch :DATA

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      (share/"iozone").install "Generate_Graphs", "client_list", "gengnuplot.sh", "gnu3d.dem", "gnuplot.dem", "gnuplotps.dem", "iozone_visualizer.pl", "report.pl"
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match /File size set to 16384 kB/, shell_output("#{bin}/iozone -I -s 16M")
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
