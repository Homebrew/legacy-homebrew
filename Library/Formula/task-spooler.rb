require 'formula'

class TaskSpooler < Formula
  homepage 'http://vicerveza.homeunix.net/~viric/soft/ts/'
  url 'http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.4.tar.gz'
  sha1 '92813a3b0eedfe1d4a177727122e6d08695f6bc8'

  patch :DATA

  conflicts_with 'moreutils',
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
__END__
diff --git a/server.c b/server.c
index a58ad87..aec0c70 100644
--- a/server.c
+++ b/server.c
@@ -179,7 +179,8 @@ void server_main(int notify_fd, char *_path)
     path = _path;

     /* Move the server to the socket directory */
-    dirpath = strdup(path);
+    dirpath = malloc(strlen(path)+1);
+    strcpy(dirpath, path);
     chdir(dirname(dirpath));
     free(dirpath);
