require 'formula'

# MongoDB depends on an older version of Spidermonkey that defines
# JS_SetBranchCallback, a function that has been deprecated in more recent
# releases.
class Spidermonkey170 < Formula
  url 'ftp://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz'
  md5 '5571134c3863686b623ebe4e6b1f6fe6'
  version '1.7.0'
  homepage 'http://mozilla.org/'

  depends_on 'readline'
  depends_on 'nspr'

  def patches
    DATA
  end
end

class MongodbDev < Formula
  url 'http://downloads.mongodb.org/src/mongodb-src-r1.8.1.tar.gz'
  homepage 'http://www.mongodb.org/'
  sha1 '615cfe4ace4899e73a7083059c7178d8f5c19f03'

  def options
    [
      ['--nojournal', 'Disable write ahead logging (Journaling).'],
      ['--rest', 'Enable the REST interface on the HTTP Console (startup port + 1000)'],
    ]
  end

  depends_on 'boost'
  depends_on 'pcre'
  depends_on 'scons' => :build

  def install
    # Installs Spidermonkey 1.7.0
    js_dir = File.join(Pathname.getwd, 'js')
    Spidermonkey170.new.brew do
      Dir.chdir 'src' do
        ENV.prepend 'CFLAGS', '-DJS_C_STRINGS_ARE_UTF8'
        ENV['JS_READLINE'] = '1'
        ENV['JS_DIST'] = js_dir
        system "make -f Makefile.ref"
        system "make -f Makefile.ref export"
      end
      FileUtils.rm("#{js_dir}/lib/libjs.dylib")
    end

    # The build and install must be separate commands.
    build_cmd = "scons . -j #{Hardware.processor_count} --extrapath js"
    install_cmd = build_cmd + " --prefix=#{prefix} --sharedclient --full install"
    system build_cmd
    system install_cmd

    # Create the data and log directories under /var
    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    # Write the configuration files and launchd script
    (prefix+'mongod.conf').write mongodb_conf
    (prefix+'org.mongodb.mongod.plist').write startup_plist
  end

  def caveats
    s = ""
    s += <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.mongodb.mongod.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mongodb.mongod.plist

    If this is an upgrade and you already have the org.mongodb.mongod.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.mongodb.mongod.plist
        cp #{prefix}/org.mongodb.mongod.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mongodb.mongod.plist

    Or start it manually:
        mongod run --config #{prefix}/mongod.conf
    EOS

    if ARGV.include? "--nojournal"
        s += ""
        s += <<-EOS.undent
        Write Ahead logging (Journaling) has been disabled.
        EOS
    else
        s += ""
        s += <<-EOS.undent
        MongoDB 1.8+ includes a feature for Write Ahead Logging (Journaling), which has been enabled by default.
        This is not the default in production (Journaling is disabled); to disable journaling, use --nojournal.
        EOS
    end

    return s
  end

  def mongodb_conf
    conf = ""
    conf += <<-EOS.undent
    # Store data in #{var}/mongodb instead of the default /data/db
    dbpath = #{var}/mongodb

    # Only accept local connections
    bind_ip = 127.0.0.1
    EOS

    if !ARGV.include? '--nojournal'
        conf += <<-EOS.undent
        # Enable Write Ahead Logging (not enabled by default in production deployments)
        journal = true
        EOS
    end

    if ARGV.include? '--rest'
        conf += <<-EOS.undent
        # Enable the REST interface on the HTTP Console (startup port + 1000)
        rest = true
        EOS
    end

    return conf
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.mongodb.mongod</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/mongod</string>
    <string>run</string>
    <string>--config</string>
    <string>#{prefix}/mongod.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/mongodb/output.log</string>
  <key>StandardOutPath</key>
  <string>#{var}/log/mongodb/output.log</string>
</dict>
</plist>
EOS
  end
end

__END__
--- a/src/jsprf.c
+++ b/src/jsprf.c
@@ -58,6 +58,8 @@
 */
 #ifdef HAVE_VA_COPY
 #define VARARGS_ASSIGN(foo, bar)        VA_COPY(foo,bar)
+#elif defined(va_copy)
+#define VARARGS_ASSIGN(foo, bar)        va_copy(foo,bar)
 #elif defined(HAVE_VA_LIST_AS_ARRAY)
 #define VARARGS_ASSIGN(foo, bar)        foo[0] = bar[0]
 #else

