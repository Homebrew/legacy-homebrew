require 'formula'

class Luciddb < Formula
  homepage 'http://www.luciddb.org/'
  url 'http://sourceforge.net/projects/luciddb/files/luciddb/luciddb-0.9.4/luciddb-bin-macos32-0.9.4.tar.bz2'
  md5 '1ae215275425b3b8dfa02355bac3c047'

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    JAVA_HOME=`/usr/libexec/java_home`
    exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    java_home = `/usr/libexec/java_home`.chomp!
    libexec.install Dir['*']
    cd libexec+'install' do
      # install.sh just sets Java classpaths and writes them to bin/classpath.gen.
      # This is why we run it /after/ copying all the files to #{libexec}.
      system "export JAVA_HOME=#{java_home} && ./install.sh"
    end
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      next if b =~ /classpath.gen/ or b =~ /defineFarragoRuntime/
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
    (prefix+'homebrew.mxcl.luciddb.plist').write luciddb_startup_plist(java_home)
  end

  def luciddb_startup_plist(java_home); <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>homebrew.mxcl.luciddb</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>JAVA_HOME</key>
        <string>#{java_home}</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{libexec}/bin/lucidDbServer</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{libexec}</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOPLIST
  end

  def caveats; <<-EOS
If this is your first install:
    mkdir -p ~/Library/LaunchAgents
    cp #{prefix}/homebrew.mxcl.luciddb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.luciddb.plist

If this is an upgrade and you already have the homebrew.mxcl.luciddb.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.luciddb.plist
    cp #{prefix}/homebrew.mxcl.luciddb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.luciddb.plist

Or start it manually by typing:
   lucidDbServer
   EOS
 end

end
