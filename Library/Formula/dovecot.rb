require 'formula'

class Dovecot < Formula
  url 'http://www.dovecot.org/releases/2.0/dovecot-2.0.15.tar.gz'
  md5 '16a08dfd24422d482440a8b03d6f7f6c'
  homepage 'http://dovecot.org/'

  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-ssl=openssl"
    system "make install"
  end

  def caveats; <<-EOS
For Dovecot to work, you will need to do the following:

1) Create configuration in #{etc}

2) If required by the configuration above, create a dovecot user and group

3) possibly create a launchd item in /Library/LaunchDaemons/org.dovecot.plist, like so:
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>org.dovecot</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>#{sbin}/dovecot</string>
                <string>-F</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceDescription</key>
        <string>Dovecot mail server</string>
</dict>
</plist>

Source: http://wiki.dovecot.org/LaunchdInstall
4) start the server using: sudo launchctl load /Library/LaunchDaemons/org.dovecot.plist
    EOS
  end
end

__END__

# This patch fixes a linking problem looking for _environ, call
# _NSGetEnviron() instead (upstream does that at another location but
# missesthis one).

diff --git a/src/lib/env-util.c b/src/lib/env-util.c
index 8111db7..c3520d0 100644
--- a/src/lib/env-util.c
+++ b/src/lib/env-util.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #ifdef __APPLE__
 #  include <crt_externs.h>
+#  define environ (*_NSGetEnviron())
 #endif

 struct env_backup {
@@ -36,7 +37,6 @@ void env_remove(const char *name)
	unsetenv(name);
 #endif
 #else
-	extern char **environ;
	unsigned int len;
	char **envp;

@@ -109,7 +109,6 @@ void env_clean_except(const char *const preserve_envs[])

 struct env_backup *env_backup_save(void)
 {
-	char **environ = *env_get_environ_p();
	struct env_backup *env;
	unsigned int i, count;
	pool_t pool;
