require 'formula'

class Siege < Formula
  homepage 'http://www.joedog.org/index/siege-home'
  url "http://www.joedog.org/pub/siege/siege-3.0.2.tar.gz"
  sha1 'e5eebb4ab61ad10831d80015133aa5c70c5392c3'

  # Fix bug related to variables evaluating
  # http://bolknote.ru/2013/07/20/~4022 (in Russian)
  def patches; DATA; end

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix+'etc').mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Mac OS X has only 16K ports available that won't be released until socket
    TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
    Consider reducing in case of available port bottleneck.

    You can check whether this is a problem with netstat:

        # sysctl net.inet.tcp.msl
        net.inet.tcp.msl: 15000

        # sudo sysctl -w net.inet.tcp.msl=1000
        net.inet.tcp.msl: 15000 -> 1000

    Run siege.config to create the ~/.siegerc config file.
    EOS
  end
end

__END__
diff --git a/src/cfg.c b/src/cfg.c
index 9b7402c..8cdffdf 100644
--- a/src/cfg.c
+++ b/src/cfg.c
@@ -168,18 +168,17 @@ read_cmd_line(LINES *l, char *url)
 BOOLEAN
 is_variable_line(char *line)
 {
-  int pos;
-  int x;
+  char *pos, *x;
   char c;

   /**
    * check for variable assignment; make sure that on the left side
    * of the = is nothing but letters, numbers, and/or underscores.
    */
-  pos = (int)strstr(line, "=");
-  if(pos > 0){
-    for(x = 0; x < (pos - (int)line); x++){
-      c = line[x];
+  pos = strstr(line, "=");
+  if(pos != NULL){
+    for (x = line; x < pos; x++) {
+      c = *x;
       /* c must be A-Z, a-z, 0-9, or underscore. */
       if ((c < 'a' || c > 'z') &&
           (c < 'A' || c > 'Z') &&
