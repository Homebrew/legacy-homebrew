class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_430.tar"
  sha256 "e8388238326dc29359e5cb9f790d193f1e1bdadfbf260e010c50fa682387faed"

  bottle do
    cellar :any
    sha1 "3e22c42f233911335ebff3183e118e2257ad9d52" => :yosemite
    sha1 "23e9d8e14fa04c276f1c58af900d14a1254163ed" => :mavericks
    sha1 "e43bdf632913d693aec55f89426cf38b67d792cc" => :mountain_lion
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
