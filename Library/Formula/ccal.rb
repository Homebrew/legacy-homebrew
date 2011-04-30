require 'formula'

# We follow the naming convention of the Debian package ccal, so as not to conflict with regular Unix cal
# http://packages.debian.org/sid/utils/ccal
class Ccal < Formula
  url 'http://unicorn.us.com/pub/cal40.zip'
  # See also http://packages.debian.org/sid/utils/ccal
  homepage 'http://unicorn.us.com/cal.html'
  md5 '412c8bbc6f768a5bb86f8c42e796c41e'

  def patches
    # Makes the documentation match the installation paths
    DATA
  end

  def install
    inreplace "cal.html" do |s|
      # We rename cal everywhere to ccal
      s.gsub! /\bcal(?![\."])\b/, "ccal"
      s.gsub! /\bCAL(?!\.)\b/, "CCAL"
      s.gsub! /sample caldat/, "sample cal.dat"
      s.gsub! /\.caldat/, ".cal.dat"
    end
    inreplace "caldat" do |s|
      s.sub! /\/usr\/lib\/caldat/, "#{etc}/cal.dat"
      s.sub! /~\/\.caldat/, "~/.cal.dat"
      s.gsub! /\bcal(?!\.)\b/i, "ccal"
    end

    Dir.chdir "src"
    inreplace "makefile.unx" do |s|
      # The escaped double quotes are necessary because of the way the code is written
      s.gsub! /^(CFLAGS=.*)/, "\\1 -DPREFIX=\\\"#{etc}/\\\""
    end
    inreplace "cal.1" do |s|
      # We rename cal everywhere to ccal
      s.gsub! /\bcal(?!\.)\b/, "ccal"
      s.gsub! /\bCAL(?!\.)\b/, "CCAL"
      s.sub! /- displays a calendar/, "- display a colored calendar"
    end

    # NOTE: the 'install' command in makefile.unx expects directories to be automatically created, which is not the case on OSX.  So we install ourselves
    system "make", "-f", "makefile.unx"

    bin.install "cal" => "ccal"
    man1.install "cal.1" => "ccal.1"

    Dir.chdir ".."
    doc.install "calcol.sample" => "cal.col.sample"
    doc.install "caldat" => "cal.dat.sample"
    doc.install "cal.html" => "ccal.html"
  end
end

__END__
--- a/src/cal.c  2002-08-11 09:03:52.000000000 +1000
+++ b/src/cal.c  2011-05-01 00:20:01.000000000 +1000
@@ -1726,9 +1726,9 @@
 void usage()
 {
 fputs("\n\
-cal 4.0 - Display a monthly or yearly calendar, with optional appointments.\n\n\
-Usages:  cal [options] [[1|2|3|...|12] year]\n\
-         cal [options] [jan|feb|mar|...|dec] [year]\n\n\
+ccal 4.0 - Display a monthly or yearly calendar, with optional appointments.\n\n\
+Usages:  ccal [options] [[1|2|3|...|12] year]\n\
+         ccal [options] [jan|feb|mar|...|dec] [year]\n\n\
 Options:\n\
   --3[months]         Display prev/current/next month\n\
   --a[ppts]=n         Display maximum of n (8-50) appointments (24)\n\
