require "formula"

class Gupnp < Formula
  homepage "https://wiki.gnome.org/GUPnP/"
  url "http://ftp.gnome.org/pub/gnome/sources/gupnp/0.20/gupnp-0.20.11.tar.xz"
  sha1 "df8fd34bc50a567610899e071e0fa724188ebcfd"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  # Per MacPorts, fix compilation with clang
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
--- a/libgupnp/gupnp-acl.c.orig	2014-05-04 07:46:07.000000000 -0700
+++ b/libgupnp/gupnp-acl.c	2014-05-04 07:48:56.000000000 -0700
@@ -129,7 +129,7 @@
                              GAsyncResult  *res,
                              GError       **error)
 {
-        g_return_if_fail (GUPNP_IS_ACL (self));
+        g_return_val_if_fail (GUPNP_IS_ACL (self), 0);
 
         return GUPNP_ACL_GET_INTERFACE (self)->is_allowed_finish (self,
                                                                   res,
@@ -149,7 +149,7 @@
 gboolean
 gupnp_acl_can_sync (GUPnPAcl *self)
 {
-        g_return_if_fail (GUPNP_IS_ACL (self));
+        g_return_val_if_fail (GUPNP_IS_ACL (self), 0);
 
         return GUPNP_ACL_GET_INTERFACE (self)->can_sync (self);
 }
