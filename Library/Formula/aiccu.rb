require 'formula'

class Aiccu < Formula
  homepage 'http://www.sixxs.net/faq/aiccu/'
  url 'http://www.sixxs.net/archive/sixxs/aiccu/unix/aiccu_20070115.tar.gz'
  sha1 '7b3c51bfe291c777e74b2688e9339b4fb72e6a39'

  # Patches per MacPorts
  def patches; DATA; end

  def install
    inreplace 'doc/aiccu.conf', 'daemonize true', 'daemonize false'
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    etc.install 'doc/aiccu.conf' unless (etc/'aiccu.conf').exist?

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/sbin/aiccu</string>
        <string>start</string>
        <string>#{HOMEBREW_PREFIX}/etc/aiccu.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats
    <<-EOS.undent
      You may also wish to install tuntap:

        The TunTap project provides kernel extensions for Mac OS X that allow
        creation of virtual network interfaces.

        http://tuntaposx.sourceforge.net/

      Because these are kernel extensions, there is no Homebrew formula for tuntap.


      Unless it exists already, a aiccu.conf file has been written to:
        #{etc}/aiccu.conf

      Protect this file as it will contain your credentials.

      The 'aiccu' command will load this file by default unless told to use
      a different one.


      To launch on startup:
      * if this is your first install:
          sudo cp #{plist_path} /Library/LaunchDaemons/
          sudo launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}

      * if this is an upgrade and you already have the #{plist_path.basename} loaded:
          sudo launchctl unload -w /Library/LaunchDaemons/#{plist_path.basename}
          sudo cp #{plist_path} /Library/LaunchDaemons/
          sudo launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}
    EOS
  end
end
__END__
diff --git a/Makefile b/Makefile
index 0e96136..78609bd 100644
--- a/Makefile
+++ b/Makefile
@@ -36,10 +36,11 @@ export DESTDIR
 CFLAGS=${RPM_OPT_FLAGS}

 # Destination Paths (relative to DESTDIR)
-dirsbin=/usr/sbin/
-dirbin=/usr/bin/
-diretc=/etc/
-dirdoc=/usr/share/doc/${PROJECT}/
+prefix=
+dirsbin=${prefix}/sbin/
+dirbin=${prefix}/bin/
+diretc=${prefix}/etc/
+dirdoc=${prefix}/share/doc/${PROJECT}/

 # Make sure the lower makefile also knows these
 export PROJECT
@@ -79,21 +80,13 @@ install: aiccu
	@echo "Configuration..."
	@mkdir -p ${DESTDIR}${diretc}
 ifeq ($(shell echo "A${RPM_BUILD_ROOT}"),A)
-	$(shell [ -f ${DESTDIR}${diretc}${PROJECT}.conf ] || cp -R doc/${PROJECT}.conf ${DESTDIR}${diretc}${PROJECT}.conf)
	@echo "Documentation..."
+	@cp doc/${PROJECT}.conf ${DESTDIR}${dirdoc}
	@cp doc/README ${DESTDIR}${dirdoc}
	@cp doc/LICENSE ${DESTDIR}${dirdoc}
	@cp doc/HOWTO  ${DESTDIR}${dirdoc}
-	@echo "Installing Debian-style init.d"
-	@mkdir -p ${DESTDIR}${diretc}init.d
-	@cp doc/${PROJECT}.init.debian ${DESTDIR}${diretc}init.d/${PROJECT}
-else
-	@echo "Installing Redhat-style init.d"
-	@mkdir -p ${DESTDIR}${diretc}init.d
-	@cp doc/${PROJECT}.init.rpm ${DESTDIR}${diretc}init.d/${PROJECT}
-	@cp doc/${PROJECT}.conf ${DESTDIR}${diretc}${PROJECT}.conf
 endif
-	@echo "Installation into ${DESTDIR}/ completed"
+	@echo "Installation into ${DESTDIR}${prefix}/ completed"

 help:
	@echo "$(PROJECT) - $(PROJECT_DESC)"
diff --git a/common/aiccu.h b/common/aiccu.h
index ef65000..5b2eb43 100755
--- a/common/aiccu.h
+++ b/common/aiccu.h
@@ -65,17 +65,17 @@
  * the data. Could be useful in the event
  * where we can't make contact to the main server
  */
-#define AICCU_CACHE	"/var/cache/aiccu.cache"
+#define AICCU_CACHE	"/usr/local/var/cache/aiccu.cache"

 /* The PID we are running as when daemonized */
-#define AICCU_PID	"/var/run/aiccu.pid"
+#define AICCU_PID	"/usr/local/var/run/aiccu.pid"

 /* AICCU Configuration file */
 #ifdef _WIN32
 /* GetWindowsDirectory() is used to figure out the directory to store the config */
 #define AICCU_CONFIG	"aiccu.conf"
 #else
-#define AICCU_CONFIG	"/etc/aiccu.conf"
+#define AICCU_CONFIG	"/usr/local/etc/aiccu.conf"
 #endif

 /* Inbound listen queue */
