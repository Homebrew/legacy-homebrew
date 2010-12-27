require 'formula'

class Aget <Formula
  url 'http://www.enderunix.org/aget/aget-0.4.1.tar.gz'
  homepage 'http://www.enderunix.org/aget/'
  md5 'ddee95ad1d394a4751ebde24fcb36fa1'

  def patches
    { :p0 => DATA }
  end

  def install
    system "make"
    # system "make strip"
    bin.install "aget"
    man1.install "aget.1"
  end
end


__END__
--- Head.c	2009-05-12 14:22:42.000000000 +0900
+++ Head.c.new	2010-10-21 00:12:25.000000000 +0900
@@ -59,7 +59,7 @@
 				hstrerror(h_errno));
 		exit(1);
 	}
-	strncpy(req->ip, inet_ntoa(*(struct in_addr *)he->h_addr), MAXIPSIZ);
+	strncpy(req->ip, inet_ntoa(*(struct in_addr *)he->h_addr_list[0]), MAXIPSIZ);
 
 
 	time(&t_start);
