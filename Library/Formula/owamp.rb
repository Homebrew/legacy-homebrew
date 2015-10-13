class Owamp < Formula
  desc "Implementation of the One-Way Active Measurement Protocol"
  homepage "http://www.internet2.edu/performance/owamp/"
  url "http://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha256 "059f0ab99b2b3d4addde91a68e6e3641c85ce3ae43b85fe9435841d950ee2fb3"

  bottle do
    cellar :any
    sha1 "e1746058ddd62ec75ec1b62be837e22c3527c37a" => :yosemite
    sha1 "45429f2d582a54caa0979b9aa533f6dff1c74ec1" => :mavericks
    sha1 "1020642e1ca36fd067828ed344799023aca8ff09" => :mountain_lion
  end

  depends_on "i2util"

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/owping", "-h"
  end
end

__END__
diff -ur owamp-3.4/owamp/endpoint.c owamp-3.4.fixed/owamp/endpoint.c
--- owamp-3.4/owamp/endpoint.c	2014-03-21 09:37:42.000000000 -0400
+++ owamp-3.4.fixed/owamp/endpoint.c	2014-11-26 07:50:11.000000000 -0500
@@ -2188,6 +2188,11 @@
         timespecsub((struct timespec*)&wake.it_value,&currtime);

         wake.it_value.tv_usec /= 1000;        /* convert nsec to usec        */
+        while (wake.it_value.tv_usec >= 1000000) {
+            wake.it_value.tv_usec -= 1000000;
+            wake.it_value.tv_sec++;
+        }
+
         tvalclear(&wake.it_interval);

         /*
