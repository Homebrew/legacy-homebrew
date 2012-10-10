require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/stable_updates/libvirt-0.9.11.6.tar.gz'
  sha256 'ad2f77a05b2c66198ea74df1640c56b3d9f394b397eae8eec612fa1cb3efb04a'

  # Patch from upstream for 0.9.11.6 only.  Will be in next release.
  def patches
    DATA if not build.devel?
  end

  # Latest (roughly) monthly release.
  devel do
    url 'http://libvirt.org/sources/libvirt-0.10.2.tar.gz'
    sha256 '1fe69ae1268a097cc0cf83563883b51780d528c6493efe3e7d94c4160cc46977'
  end

  option 'without-libvirtd', 'Build only the virsh client and development libraries'

  depends_on "gnutls"
  depends_on "yajl"

  if MacOS.version == :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}",
            "--with-esx",
            "--with-init-script=none",
            "--with-remote",
            "--with-test",
            "--with-vbox",
            "--with-vmware",
            "--with-yajl",
            "--without-qemu"]

    args << "--without-libvirtd" if build.include? 'without-libvirtd'

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf" do |s|
      s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
    end

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    unless build.include? 'without-libvirtd'
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end
end

__END__
diff --git a/src/util/virnetdev.c b/src/util/virnetdev.c
index 06004ab..d53352f 100644
--- a/src/util/virnetdev.c
+++ b/src/util/virnetdev.c
@@ -929,7 +929,7 @@ int virNetDevValidateConfig(const char *ifname,
 }
 #else /* ! HAVE_STRUCT_IFREQ */
 int virNetDevValidateConfig(const char *ifname ATTRIBUTE_UNUSED,
-                            const virMacAddrPtr macaddr ATTRIBUTE_UNUSED,
+                            const unsigned char *macaddr ATTRIBUTE_UNUSED,
                             int ifindex ATTRIBUTE_UNUSED)
 {
     virReportSystemError(ENOSYS, "%s",
@@ -1663,7 +1663,7 @@ virNetDevLinkDump(const char *ifname ATTRIBUTE_UNUSED,
 int
 virNetDevReplaceNetConfig(char *linkdev ATTRIBUTE_UNUSED,
                           int vf ATTRIBUTE_UNUSED,
-                          const virMacAddrPtr macaddress ATTRIBUTE_UNUSED,
+                          const unsigned char *macaddress ATTRIBUTE_UNUSED,
                           int vlanid ATTRIBUTE_UNUSED,
                           char *stateDir ATTRIBUTE_UNUSED)
 {
diff --git a/src/util/virnetlink.c b/src/util/virnetlink.c
index 2772d9b..0e4d76b 100644
--- a/src/util/virnetlink.c
+++ b/src/util/virnetlink.c
@@ -672,7 +672,7 @@ int virNetlinkEventServiceLocalPid(void)
 int virNetlinkEventAddClient(virNetlinkEventHandleCallback handleCB ATTRIBUTE_UNUSED,
                              virNetlinkEventRemoveCallback removeCB ATTRIBUTE_UNUSED,
                              void *opaque ATTRIBUTE_UNUSED,
-                             const virMacAddrPtr macaddr ATTRIBUTE_UNUSED)
+                             const unsigned char *macaddr ATTRIBUTE_UNUSED)
 {
     netlinkError(VIR_ERR_INTERNAL_ERROR, "%s", _(unsupported));
     return -1;
@@ -682,7 +682,7 @@ int virNetlinkEventAddClient(virNetlinkEventHandleCallback handleCB ATTRIBUTE_UN
  * virNetlinkEventRemoveClient: unregister a callback from a netlink monitor
  */
 int virNetlinkEventRemoveClient(int watch ATTRIBUTE_UNUSED,
-                                const virMacAddrPtr macaddr ATTRIBUTE_UNUSED)
+                                const unsigned char *macaddr ATTRIBUTE_UNUSED)
 {
     netlinkError(VIR_ERR_INTERNAL_ERROR, "%s", _(unsupported));
     return -1;
