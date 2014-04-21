require 'formula'

class Vpnc < Formula
  homepage 'http://www.unix-ag.uni-kl.de/~massar/vpnc/'
  url 'http://ftp.debian.org/debian/pool/main/v/vpnc/vpnc_0.5.3r512.orig.tar.gz'
  version '0.5.3r512'
  sha256 'd421ac20b6c65d22d2ee88066e487f740f4d367f9143b6045bcb8fa177b384fe'
  revision 2

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libgpg-error'
  depends_on 'gnutls'
  depends_on 'tuntap'

  fails_with :llvm do
    build 2334
  end

  option "hybrid", "Use vpnc hybrid authentication"

  # Patch from user @Imagesafari to enable compilation on Lion
  patch :DATA if MacOS.version >= :lion

  def install
    ENV.no_optimization
    ENV.deparallelize

    inreplace ["vpnc-script", "vpnc-disconnect"] do |s|
      s.gsub! "/var/run/vpnc", (var + 'run/vpnc')
    end

    inreplace "vpnc.8.template" do |s|
      s.gsub! "/etc/vpnc", (etc + 'vpnc')
    end

    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "ETCDIR", (etc + 'vpnc')

      s.gsub! /^#OPENSSL/, "OPENSSL" if build.include? "hybrid"
    end

    inreplace "config.c" do |s|
      s.gsub! "/etc/vpnc", (etc + 'vpnc')
      s.gsub! "/var/run/vpnc", (var + 'run/vpnc')
    end

    system "make"
    (var + 'run/vpnc').mkpath
    system "make install"
  end
end

__END__
--- vpnc/sysdep.h	2008-11-19 15:36:12.000000000 -0500
+++ vpnc.patched/sysdep.h	2011-07-14 12:49:18.000000000 -0400
@@ -109,6 +109,8 @@
 #define HAVE_FGETLN    1
 #define HAVE_UNSETENV  1
 #define HAVE_SETENV    1
+#define HAVE_GETLINE   1
+#define NEW_TUN        1
 #endif
 
 /***************************************************************************/
diff -u vpnc.patched/vpnc-script vpnc/vpnc-script
--- vpnc.patched/vpnc-script	2013-11-01 13:17:21.000000000 -0700
+++ vpnc/vpnc-script	2013-11-01 18:54:33.000000000 -0700
@@ -388,7 +388,7 @@
				scutil >/dev/null 2>&1 <<-EOF
					open
					d.init
-					d.add ServerAddresses * $INTERNAL_IP4_DNS
+					d.add ServerAddresses * $INTERNAL_IP4_DNS $INTERNAL_IP6_DNS
					set State:/Network/Service/$TUNDEV/DNS
					d.init
					# next line overrides the default gateway and breaks split routing
@@ -598,7 +598,7 @@
			fi
			i=`expr $i + 1`
		done
-		for i in $INTERNAL_IP4_DNS ; do
+		for i in $INTERNAL_IP6_DNS ; do
			if echo "$i" | grep : >/dev/null; then
				set_ipv6_network_route "$i" "128"
			fi
