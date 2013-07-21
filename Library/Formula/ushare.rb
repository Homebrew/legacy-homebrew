require 'formula'

class Ushare < Formula
  homepage 'http://ushare.geexbox.org/'
  url 'http://ushare.geexbox.org/releases/ushare-1.1a.tar.bz2'
  sha1 '1539e83cde5d80f433d262d971f5fe78486c9375'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'libupnp'
  depends_on 'libdlna'

  # Correct "OPTFLAGS" to "CFLAGS"
  def patches
  { :p0 =>
    "https://trac.macports.org/export/89267/trunk/dports/net/ushare/files/patch-configure.diff",
    :p1 => DATA,
  }
  end

  fails_with :clang do
    cause "clang removes inline functions, causing a link error:\n" +
          "\"_display_headers\", referenced from: _parse_command_line in cfgparser.o"
  end

  def install
    # Need to explicitly add intl and gettext here.
    gettext = Formula.factory("gettext")
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
