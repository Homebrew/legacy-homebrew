class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/libproxy-0.4.11.tar.gz"
  sha256 "af3525f9fdbe8d45ba4449ed1f02d01c21ad0bb5c31573e07f66be453c5f3a53"

  stable do
    # Fix Build on Mac OS X - Fixes bug 183 -- https://github.com/libproxy/libproxy/commit/25cc320452726924697de856e523c52acaa75645
    # Fix compilation errors with clang -- https://github.com/andyetitmoves/libproxy/commit/baa844d5992c30e996ae7a552d7afee7099e8dfb
    # Including both patches inline as DATA since the original patch apply on other changes and hence fail on this release
    patch :DATA
  end

  head do
    url "https://github.com/libproxy/libproxy.git"
    patch do
      url "https://github.com/andyetitmoves/libproxy/commit/baa844d5992c30e996ae7a552d7afee7099e8dfb.diff"
      sha256 "ac714f2cc010a5428556b4b66a42f4df043a6f42540269bba7da11a773f7529c"
    end
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      # The build tries to install to non-standard locations for Python bindings, hence avoid it..
      system "cmake", "..", "-DWITH_PYTHON=no", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/proxy", "127.0.0.1"
  end
end

__END__
diff --git a/libproxy/modules/config_macosx.cpp b/libproxy/modules/config_macosx.cpp
index 1c43000..38e4065 100644
--- a/libproxy/modules/config_macosx.cpp
+++ b/libproxy/modules/config_macosx.cpp
@@ -114,7 +114,7 @@ static string capitalize(string str) {
 
 class macosx_config_extension : public config_extension {
 public:
-	vector<url> get_config(const url &url) throw (runtime_error) {
+	vector<url> get_config(const url &the_url) throw (runtime_error) {
 		string tmp;
 		CFDictionaryRef proxies = SCDynamicStoreCopyProxies(NULL);
 		vector<url> response;
@@ -136,8 +136,8 @@ public:
 		}
 
 		// http:// or socks:// (TODO: gopher:// and rtsp:// ???)
-		else if ((protocol_url(proxies, toupper(url.get_scheme()), tmp)    && url::is_valid(tmp)) ||
-		    (protocol_url(proxies, capitalize(url.get_scheme()), tmp) && url::is_valid(tmp)) ||
+		else if ((protocol_url(proxies, toupper(the_url.get_scheme()), tmp)    && url::is_valid(tmp)) ||
+		    (protocol_url(proxies, capitalize(the_url.get_scheme()), tmp) && url::is_valid(tmp)) ||
 		    (protocol_url(proxies, toupper("http"), tmp)              && url::is_valid(tmp)) ||
 	            (protocol_url(proxies, toupper("socks"), tmp)             && url::is_valid(tmp))) {
 			CFRelease(proxies);
diff --git a/libproxy/test/get-pac-test.cpp b/libproxy/test/get-pac-test.cpp
index a61fc4b..b452314 100644
--- a/libproxy/test/get-pac-test.cpp
+++ b/libproxy/test/get-pac-test.cpp
@@ -3,9 +3,11 @@
 #include <sstream>
 #include <string>
 
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
+#include <sys/select.h>
 #include <unistd.h>
 #include <string.h>
 #include <pthread.h>
@@ -32,7 +34,7 @@ class TestServer {
 			int i = 1;
 
 			addr.sin_family = AF_INET;
-			inet_aton("127.0.0.1", &addr.sin_addr);
+			addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 			addr.sin_port = ntohs(m_port);
 
 			if (m_sock != -1)
