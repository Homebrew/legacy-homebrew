require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'ftp://libvirt.org/libvirt/libvirt-0.9.3.tar.gz'
  sha256 '4d673be9aa7b5618c0fef3cfdbbbeff02df1c83e26680fe40defad2b32a56ae3'

  depends_on "gnutls"
  depends_on "yajl"

  if MacOS.leopard?
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  def patches
    # Patch to work around a compilation bug; fixed in libvirt 0.9.4
    DATA
  end

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def options
    [['--without-libvirtd', 'Build only the virsh client and development libraries.']]
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
            "--with-vbox=check",
            "--with-vmware",
            "--with-yajl"]

    args << "--without-libvirtd" if ARGV.include? '--without-libvirtd'

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf" do |s|
      s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
      s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
    end

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    unless ARGV.include? '--without-libvirtd'
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end
end

__END__
diff --git a/src/conf/network_conf.h b/src/conf/network_conf.h
index d7d2951..5edcf27 100644
--- a/src/conf/network_conf.h
+++ b/src/conf/network_conf.h
@@ -64,22 +64,22 @@ struct _virNetworkDNSTxtRecordsDef {
     char *value;
 };

-struct virNetworkDNSHostsDef {
+struct _virNetworkDNSHostsDef {
     virSocketAddr ip;
     int nnames;
     char **names;
-} virNetworkDNSHostsDef;
+};

-typedef struct virNetworkDNSHostsDef *virNetworkDNSHostsDefPtr;
+typedef struct _virNetworkDNSHostsDef *virNetworkDNSHostsDefPtr;

-struct virNetworkDNSDef {
+struct _virNetworkDNSDef {
     unsigned int ntxtrecords;
     virNetworkDNSTxtRecordsDefPtr txtrecords;
     unsigned int nhosts;
     virNetworkDNSHostsDefPtr hosts;
-} virNetworkDNSDef;
+};

-typedef struct virNetworkDNSDef *virNetworkDNSDefPtr;
+typedef struct _virNetworkDNSDef *virNetworkDNSDefPtr;

 typedef struct _virNetworkIpDef virNetworkIpDef;
 typedef virNetworkIpDef *virNetworkIpDefPtr;
--
1.7.4.1

