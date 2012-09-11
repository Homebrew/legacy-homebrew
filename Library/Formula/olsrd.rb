require 'formula'

class Olsrd < Formula
  homepage 'http://www.olsr.org'
  url 'http://www.olsr.org/releases/0.6/olsrd-0.6.3.tar.bz2'
  version '0.6.3'
  sha1 'd949a46904e2c2ff694e8350cc5bbffb26d5011b'

  def install
    custom_vars = "DESTDIR=#{prefix} USRDIR=#{prefix}"
    system "make #{custom_vars} build_all" 
    system "make #{custom_vars} install_olsrd"
    lib.install Dir['lib/*/*.so.*'] 
  end

  #this patch is required only for Mountain Lion
  if `sw_vers -productVersion` =~ /^10\.8\./
    def patches
      # The build fails because OS X defaults to RFC2292 and 
      #  requires __APPLE_USE_RFC_3542 to be set to use the newer defines.
      # http://olsr.org/bugs/print_bug_page.php?bug_id=35
      DATA
    end
  end

  def caveats; <<-EOS.undent
    ========= C O N F I G U R A T I O N - F I L E ============
    olsrd uses the configfile /etc/olsrd.conf
    a default configfile. A sample RFC-compliance aimed
    configfile can be found in olsrd.conf.default.rfc.
    However none of the larger OLSRD using networks use that
    so install a configfile with activated link quality exstensions
    per default.
    can be found at files/olsrd.conf.default.lq
    ==========================================================

    -------------------------------------------
    Copy and edit #{prefix}/etc/olsrd.conf to /etc/olsrd.conf before running olsrd!!
    -------------------------------------------
    EOS
  end

  def test
    `#{sbin}/olsrd 2>/dev/null`.split("\n")[1].chomp == ' *** olsr.org -  0.6.3-git_-hash_78a8f0fcb9d6e69ec2f8e14db404aa27 ***'
  end
end

__END__
diff --git a/src/bsd/net.c b/src/bsd/net.c
index de877c1..cce8bb8 100644
--- a/src/bsd/net.c
+++ b/src/bsd/net.c
@@ -39,6 +39,8 @@
  *
  */
 
+/* This is neede to get new style options, see netinet6/in6.h */
+#define __APPLE_USE_RFC_3542 1 
 #if defined __FreeBSD_kernel__
 #define _GNU_SOURCE 1
 #endif
