require 'formula'

class Olsrd < Formula
  homepage 'http://www.olsr.org'
  url 'http://www.olsr.org/releases/0.6/olsrd-0.6.6.1.tar.bz2'
  sha1 '0d74708dd94ad978af061a44758f8ea31845261f'

  #Release is broken and assumes git repository
  patch :DATA

  def install
    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
    ]
    system 'make', 'build_all', *args
    system 'make', 'install_all', *args
  end

  plist_options :startup => true, :manual => "olsrd -f #{HOMEBREW_PREFIX}/etc/olsrd.conf"

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
          <string>-f</string>
          <string>#{etc}/olsrd.conf</string>
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
diff --git a/Makefile b/Makefile
index 2df56aa..a24fa98 100644
--- a/Makefile
+++ b/Makefile
@@ -88,7 +88,7 @@ switch:
 src/builddata.c:
 	$(MAKECMDPREFIX)$(RM) "$@"
 	$(MAKECMDPREFIX)echo "#include \"defs.h\"" >> "$@" 
-	$(MAKECMDPREFIX)echo "const char olsrd_version[] = \"olsr.org -  $(VERS)`./make/hash_source.sh`\";"  >> "$@"
+	$(MAKECMDPREFIX)echo "const char olsrd_version[] = \"olsr.org -  $(VERS)\";" >> "$@"
 	$(MAKECMDPREFIX)date +"const char build_date[] = \"%Y-%m-%d %H:%M:%S\";" >> "$@" 
 	$(MAKECMDPREFIX)echo "const char build_host[] = \"$(shell hostname)\";" >> "$@" 
 
