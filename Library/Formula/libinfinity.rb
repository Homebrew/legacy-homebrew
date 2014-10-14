require 'formula'

class Libinfinity < Formula
  homepage 'http://gobby.0x539.de/trac/wiki/Infinote/Libinfinity'
  url 'http://releases.0x539.de/libinfinity/libinfinity-0.5.4.tar.gz'
  sha1 '75e3349452bdd182a385f62100c09f47b277b145'
  revision 1

  bottle do
    sha1 "e361f9f9fe5323bddccb4d47966a9920b2d93c39" => :mavericks
    sha1 "5be4eb2a739c4bbe00f409b81f9721577809d861" => :mountain_lion
    sha1 "e99f4d2708964047363a20ee31b0acd16272c784" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'gnutls'
  depends_on 'gsasl'
  depends_on :x11

  # Reported and closed upstream, but not seeing the fix:
  # http://gobby.0x539.de/trac/ticket/595
  patch :DATA

  # MacPorts patch to fix pam include
  patch :p0 do
    url "https://trac.macports.org/export/92297/trunk/dports/comms/libinfinity/files/patch-infinoted-infinoted-pam.c.diff"
    sha1 "30bdd7dc80bf50fc1e0d9747fc67d84b229c01ef"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/libinfinity/communication/inf-communication-method.c b/libinfinity/communication/inf-communication-method.c
index 8526ab8..12a9923 100644
--- a/libinfinity/communication/inf-communication-method.c
+++ b/libinfinity/communication/inf-communication-method.c
@@ -299,13 +299,13 @@ inf_communication_method_received(InfCommunicationMethod* method,
 {
   InfCommunicationMethodIface* iface;
 
-  g_return_if_fail(INF_COMMUNICATION_IS_METHOD(method));
-  g_return_if_fail(INF_IS_XML_CONNECTION(connection));
-  g_return_if_fail(inf_communication_method_is_member(method, connection));
-  g_return_if_fail(xml != NULL);
+  g_return_val_if_fail(INF_COMMUNICATION_IS_METHOD(method), NULL);
+  g_return_val_if_fail(INF_IS_XML_CONNECTION(connection), NULL);
+  g_return_val_if_fail(inf_communication_method_is_member(method, connection), NULL);
+  g_return_val_if_fail(xml != NULL, NULL);
 
   iface = INF_COMMUNICATION_METHOD_GET_IFACE(method);
-  g_return_if_fail(iface->received != NULL);
+  g_return_val_if_fail(iface->received != NULL, NULL);
 
   return iface->received(method, connection, xml);
 }
