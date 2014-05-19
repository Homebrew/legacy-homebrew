require "formula"

class Udptunnel < Formula
  homepage "http://wiki.leipzig.freifunk.net/Udptunnel"
  url "http://www.cs.columbia.edu/~lennox/udptunnel/udptunnel-1.1.tar.gz"
  sha1 "c768097d9bca23d6be35931b010b75a451f34eb8"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # udptunnel -h should always return EXIT_SUCCESS, not an error. This also helps with testing.
  patch :p1, :DATA

  test do
    system "#{bin}/udptunnel", "-h"
  end
end

__END__
diff --git a/udptunnel.c b/udptunnel.c
index 561870c..ebfdd68 100644
--- a/udptunnel.c
+++ b/udptunnel.c
@@ -58,7 +58,7 @@ static int debug = 0;
  * usage()
  * Print the program usage info, and exit.
  */
-static void usage(char *progname) {
+static void usage(char *progname, int returncode) {
   fprintf(stderr, "Usage: %s -s TCP-port [-r] [-v] UDP-addr/UDP-port[/ttl]\n",
           progname);
   fprintf(stderr, "    or %s -c TCP-addr[/TCP-port] [-r] [-v] UDP-addr/UDP-port[/ttl]\n",
@@ -68,7 +68,7 @@ static void usage(char *progname) {
   fprintf(stderr, "     -r: RTP mode.  Connect/listen on ports N and N+1 for both UDP and TCP.\n");
   fprintf(stderr, "         Port numbers must be even.\n");
   fprintf(stderr, "     -v: Verbose mode.  Specify -v multiple times for increased verbosity.\n");
-  exit(2);
+  exit(returncode);
 } /* usage */
 
 
@@ -122,8 +122,10 @@ static void parse_args(int argc, char *argv[], struct relay **relays,
       break;
     case 'h':
     case '?':
+      usage(argv[0], EXIT_SUCCESS);
+      break;
     default:
-      usage(argv[0]);
+      usage(argv[0], 2);
       break;
     }
   }
@@ -135,13 +137,13 @@ static void parse_args(int argc, char *argv[], struct relay **relays,
   }
 
   if (argc <= optind) {
-    usage(argv[0]);
+    usage(argv[0], 2);
   }
 
   udphostname = strtok(argv[optind], ":/ ");
   udpportstr = strtok(NULL, ":/ ");
   if (udpportstr == NULL) {
-    usage(argv[0]);
+    usage(argv[0], 2);
   }
   udpttlstr = strtok(NULL, ":/ ");
 
