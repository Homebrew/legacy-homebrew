require 'formula'

class Samba < Formula
  homepage 'http://samba.org/'
  url 'http://samba.org/samba/ftp/stable/samba-3.6.5.tar.gz'
  sha1 'e41611c95b2bb91c7735928742b8aff4fc0da76e'

  # Needed for autogen.sh
  depends_on :automake
  depends_on :libtool

  # Fixes the Grouplimit of 16 users os OS X.
  # Bug has been raised upstream:
  # https://bugzilla.samba.org/show_bug.cgi?id=8773
  def patches
    DATA
  end

  def install
    cd 'source3' do
      system "./autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-configdir=#{prefix}/etc"
      system "make install"
      (prefix+'etc').mkpath
      system "touch", "#{prefix}/etc/smb.conf"
    end
  end
end

__END__
--- a/source3/lib/system.c	2012-02-22 22:46:14.000000000 -0200
+++ b/source3/lib/system.c	2012-02-22 22:47:51.000000000 -0200
@@ -1161,7 +1161,14 @@
 
 int groups_max(void)
 {
-#if defined(SYSCONF_SC_NGROUPS_MAX)
+#if defined(DARWINOS)
+	/* On OS X, sysconf(_SC_NGROUPS_MAX) returns 16
+	 * due to OS X's group nesting and getgrouplist
+	 * will return a flat list; users can exceed the
+	 * maximum of 16 groups. And easily will.
+	 */
+	return 32; // NGROUPS_MAX is defined, hence the define above is void.
+#elif defined(SYSCONF_SC_NGROUPS_MAX)
 	int ret = sysconf(_SC_NGROUPS_MAX);
 	return (ret == -1) ? NGROUPS_MAX : ret;
 #else
