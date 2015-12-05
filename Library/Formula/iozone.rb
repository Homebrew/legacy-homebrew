class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_430.tar"
  sha256 "e8388238326dc29359e5cb9f790d193f1e1bdadfbf260e010c50fa682387faed"

  bottle do
    cellar :any
    sha256 "6a011fd309a2eed8f726202339b1f8671eaccfc080f41f38aee9a9f76b9e4d86" => :yosemite
    sha256 "05781c01a4a0cc49dba04466d94af788b0c783e68876f9bde302b30880407738" => :mavericks
    sha256 "b31412026e024bf635eec5a3ad750657ef3dfca590388ef8f56429039ea708ad" => :mountain_lion
  end

  # Patch by @nijotz, adds O_DIRECT support when using -I flag.
  # See: https://github.com/Homebrew/homebrew/pull/10585
  patch :DATA

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      shared = %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                  gnuplot.dem gnuplotps.dem iozone_visualizer.pl report.pl]
      (share/"iozone").install(*shared)
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
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
