require 'formula'

class Ushare < Formula
  homepage 'http://ushare.geexbox.org/'
  url 'http://ushare.geexbox.org/releases/ushare-1.1a.tar.bz2'
  sha1 '1539e83cde5d80f433d262d971f5fe78486c9375'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'libupnp'
  depends_on 'libdlna'

  # Fix compilation with newer libupnp
  patch :DATA

  def install
    ENV.append 'CFLAGS', '-std=gnu89'

    # Need to explicitly add intl and gettext here.
    gettext = Formula["gettext"]
    ENV.append 'CFLAGS', "-I#{gettext.include}"
    ENV.append 'LDFLAGS', "-lintl"

    inreplace 'configure', /config.h/, 'src/config.h'
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dlna",
                          "--with-libupnp-dir=#{HOMEBREW_PREFIX}",
                          "--with-libdlna-dir=#{HOMEBREW_PREFIX}",
                          "--disable-strip"
    system "make install"
    man1.install "src/ushare.1"
  end
end

__END__
diff --git a/src/ushare.c b/src/ushare.c
index 717e862..8e51bf7 100644
--- a/src/ushare.c
+++ b/src/ushare.c
@@ -188,7 +188,7 @@ handle_action_request (struct Upnp_Action_Request *request)
   if (strcmp (request->DevUDN + 5, ut->udn))
     return;
 
-  ip = request->CtrlPtIPAddr.s_addr;
+  ip = ((struct sockaddr *) &request->CtrlPtIPAddr)->sa_data;
   ip = ntohl (ip);
   sprintf (val, "%d.%d.%d.%d",
            (ip >> 24) & 0xFF, (ip >> 16) & 0xFF, (ip >> 8) & 0xFF, ip & 0xFF);
