
class VampPluginSdk < Formula
  homepage "http://www.vamp-plugins.org/"
  url "https://sourceforge.net/projects/vamp/files/vamp-plugin-sdk/2.2.1/vamp-plugin-sdk-2.2.1.tar.gz"
  sha256 "571481098270133d2b78c6a461b850e04a98ab38284227c4d8056385f6333c26"

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  patch :p1, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index e7e35f8..644a239 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -102,10 +102,10 @@ PLUGIN_LDFLAGS		= $(DYNAMIC_LDFLAGS) -Wl,--version-script=build/vamp-plugin.map
 
 
 ## For OS/X with g++:
-#DYNAMIC_LDFLAGS		= -dynamiclib
-#PLUGIN_LDFLAGS			= $(DYNAMIC_LDFLAGS)
-#SDK_DYNAMIC_LDFLAGS		= $(DYNAMIC_LDFLAGS)
-#HOSTSDK_DYNAMIC_LDFLAGS	= $(DYNAMIC_LDFLAGS)
+DYNAMIC_LDFLAGS		= -dynamiclib
+PLUGIN_LDFLAGS			= $(DYNAMIC_LDFLAGS)
+SDK_DYNAMIC_LDFLAGS		= $(DYNAMIC_LDFLAGS) -Wl,-dylib_install_name,$(INSTALL_SDK_LIBS)/$(INSTALL_SDK_LINK_ABI)
+HOSTSDK_DYNAMIC_LDFLAGS	= $(DYNAMIC_LDFLAGS) -Wl,-dylib_install_name,$(INSTALL_SDK_LIBS)/$(INSTALL_HOSTSDK_LINK_ABI)
 
 
 ### End of user-serviceable parts
