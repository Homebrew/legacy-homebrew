require 'formula'

class Aggregate <Formula
  url 'http://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  homepage 'http://freshmeat.net/projects/aggregate/'   # can't find a better ref
  md5 '6fcc515388bf2c5b0c8f9f733bfee7e1'

  def patches
    # Fix simultaneous use of -t and -p options.
    # (taken from http://www.freebsd.org/cgi/cvsweb.cgi/ports/net-mgmt/aggregate/files/patch-aggregate.c)
    { :p0 => DATA }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make all"
    bin.mkdir
    man.mkpath
    %w[
        aggregate aggregate-ios
    ].each do |prog|
        bin.install prog
        man1.install gzip(prog+".1")
    end
  end
end

__END__
--- aggregate.c.orig	Wed Mar  6 16:59:37 2002
+++ aggregate.c	Thu Dec  9 20:38:55 2010
@@ -261,8 +261,18 @@
           moanf(0, "[line %d] line too long; ignoring line", line);
         continue;
       }
+      if (buf[i] == '/') {
+	      masklen = atoi(buf + i + 1);
+	      if (masklen < 1 || masklen > max_prefix_length)
+	      {
+		if (!quiet)
+		  moanf(0, "[line %d] mask length %d out of range; ignoring line", \
+		    line, masklen);
+		continue;
+	      }
+      } else
+	      masklen = default_prefix_length;
       buf[i] = 0;
-      masklen = default_prefix_length;
     } else {
       i = 0;
       while (buf[i] != '/' && i < MAX_buf) i++;
