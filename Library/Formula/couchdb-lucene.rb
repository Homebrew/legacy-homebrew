require 'formula'

class CouchdbLucene < Formula
  version  '0.6.0'
  url      'https://github.com/downloads/rnewson/couchdb-lucene/couchdb-lucene-0.6.0-dist.tar.gz'
  md5      '1a4adcc7a791cd9a5384553759c38ec6'

  head     'git://github.com/rnewson/couchdb-lucene.git'

  homepage 'https://github.com/rnewson/couchdb-lucene'

  depends_on 'couchdb'
  depends_on 'maven'

  def install
    if ARGV.build_head?
      system "mvn", "-DskipTests=true"
      system "pwd"
      system "tar", "-xzf #{Dir.pwd}/target/couchdb-lucene-0.7-SNAPSHOT-dist.tar.gz"
      prefix.install Dir["couchdb-lucene-0.7-SNAPSHOT/*"]
    else
      system "pwd"
      prefix.install Dir["couchdb-lucene-#{version}/*"]
    end

    (etc + "couchdb/local.d/couchdb-lucene.ini").write ini_file
    (prefix + "couchdb-lucene.plist").write plist_file
  end

  def caveats; <<-EOS
You can enable couchdb-lucene to automatically load on login with:

  mkdir -p ~/Library/LaunchAgents
  cp "#{prefix}/couchdb-lucene.plist" ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/couchdb-lucene.plist

Or start it manually with:
  #{bin}/run
EOS
  end

  def ini_file
    return <<-EOS
[couchdb]
os_process_timeout=60000 ; increase the timeout from 5 seconds.

[external]
fti=#{`which python`.chomp} #{prefix}/tools/couchdb-external-hook.py

[httpd_db_handlers]
_fti = {couch_httpd_external, handle_external_req, <<"fti">>}
EOS
  end

  def plist_file
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>couchdb-lucene</string>
    <key>EnvironmentVariables</key>
    <dict>
      <key>HOME</key>
      <string>~</string>
      <key>DYLD_LIBRARY_PATH</key>
      <string>/opt/local/lib:$DYLD_LIBRARY_PATH</string>
    </dict>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/run</string>
    </array>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>StandardOutPath</key>
    <string>/dev/null</string>
    <key>StandardErrorPath</key>
    <string>/dev/null</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>
EOS
  end
end
