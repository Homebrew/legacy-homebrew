require 'formula'

class CouchdbLucene < Formula
  homepage 'https://github.com/rnewson/couchdb-lucene'
  url 'https://github.com/rnewson/couchdb-lucene/tarball/v0.9.0'
  sha1 'f5c29f5d76c70ef25ed240b0a04658ec6120a0fd'

  depends_on 'couchdb'
  depends_on 'maven'

  def install
    system "mvn"

    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz"
    prefix.install Dir["couchdb-lucene-#{version}/*"]

    (etc + "couchdb/local.d/couchdb-lucene.ini").write ini_file
  end

  def ini_file; <<-EOS.undent
    [httpd_global_handlers]
    _fti = {couch_httpd_proxy, handle_proxy_req, <<"http://127.0.0.1:5985">>}
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/couchdb-lucene/bin/run"

  def plist; <<-EOS.undent
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
          <string>#{opt_prefix}/bin/run</string>
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
