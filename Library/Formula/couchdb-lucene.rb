require 'formula'

class CouchdbLucene < Formula
  url 'https://github.com/rnewson/couchdb-lucene/tarball/v0.8.0'
  homepage 'https://github.com/rnewson/couchdb-lucene'
  md5 '3d4d321881188247b80847429f514639'

  depends_on 'couchdb'
  depends_on 'maven'

  def install
    system "mvn"

    system "tar -xzf target/couchdb-lucene-#{version}-dist.tar.gz"
    system "mv couchdb-lucene-#{version}/* #{prefix}"

    (etc + "couchdb/local.d/couchdb-lucene.ini").write ini_file
    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    You can enable couchdb-lucene to automatically load on login with:

      mkdir -p ~/Library/LaunchAgents
      cp "#{plist_path}" ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start it manually with:
      #{bin}/run
    EOS
  end

  def ini_file
    return <<-EOS
[couchdb]
os_process_timeout=60000 ; increase the timeout from 5 seconds.

[external]
fti=#{which 'python'} #{prefix}/tools/couchdb-external-hook.py

[httpd_db_handlers]
_fti = {couch_httpd_external, handle_external_req, <<"fti">>}
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>EnvironmentVariables</key>
    <dict>
      <key>HOME</key>
      <string>~</string>
      <key>DYLD_LIBRARY_PATH</key>
      <string>/opt/local/lib:$DYLD_LIBRARY_PATH</string>
    </dict>
    <key>ProgramArguments</key>
    <array>
      <string>#{HOMEBREW_PREFIX}/bin/run</string>
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
