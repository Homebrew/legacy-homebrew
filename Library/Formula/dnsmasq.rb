require 'formula'

class Dnsmasq < Formula
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.67.tar.gz'
  sha1 '550c7ea2bef2a74a089c664d95fc52420a8cb726'

  depends_on 'pkg-config' => :build
  depends_on "libidn" => :optional

  def patches; DATA; end

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    make_vars = ["PREFIX=#{prefix}"]

    make_vars << "CFLAGS=-DHAVE_IDN" if build.with? 'libidn'

    system "make", "install", *make_vars

    prefix.install "dnsmasq.conf.example"
  end

  def caveats; <<-EOS.undent
    To configure dnsmasq, copy the example configuration to #{etc}/dnsmasq.conf
    and edit to taste.

      cp #{opt_prefix}/dnsmasq.conf.example #{etc}/dnsmasq.conf
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/sbin/dnsmasq</string>
          <string>--keep-in-foreground</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/src/bpf.c b/src/bpf.c
index 390d076..17f75f8 100644
--- a/src/bpf.c
+++ b/src/bpf.c
@@ -145,7 +145,7 @@ int iface_enumerate(int family, void *parm, int (*callback)())
 	      int i, j, prefix = 0;
 	      u32 valid = 0xffffffff, preferred = 0xffffffff;
 	      int flags = 0;
-#ifdef HAVE_BSD_NETWORK
+#ifdef defined(HAVE_BSD_NETWORK) && !defined(__APPLE__)
 	      struct in6_ifreq ifr6;
 
 	      memset(&ifr6, 0, sizeof(ifr6));
