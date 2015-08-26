class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "http://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/rel-1.0.1.tar.gz"
  sha256 "971ee8fff7eb195785031dedd7c06cb3fa8649fba8aa45c6ace746a23b8093a9"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"

  # fix for macosx
  # already present in HEAD so it can be removed after version 1.0.1
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    system bin/"asciigraph"
  end
end

__END__
diff --git a/src/SeExpr/SeExprFunc.cpp b/src/SeExpr/SeExprFunc.cpp
index feb6b45..8269b39 100644
--- a/src/SeExpr/SeExprFunc.cpp
+++ b/src/SeExpr/SeExprFunc.cpp
@@ -208,7 +208,7 @@ SeExprFunc::getDocString(const char* functionName)

 #ifndef SEEXPR_WIN32

-#ifdef __APPLE__
+#if defined(__APPLE__) && __MAC_OS_X_VERSION_MIN_REQUIRED <= __MAC_10_7
 static int MatchPluginName(struct dirent* dir)
 #else
 static int MatchPluginName(const struct dirent* dir)
diff --git a/src/SeExpr/SePlatform.h b/src/SeExpr/SePlatform.h
index 32a6b96..82b0f44 100644
--- a/src/SeExpr/SePlatform.h
+++ b/src/SeExpr/SePlatform.h
@@ -40,6 +40,10 @@ OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
     @brief Platform-specific classes, functions, and includes.
 */

+#ifdef __APPLE__
+#    include <Availability.h>
+#endif
+
 // platform-specific includes
 #if defined(_WIN32) || defined(_WINDOWS) || defined(_MSC_VER)
 #    ifndef WINDOWS
