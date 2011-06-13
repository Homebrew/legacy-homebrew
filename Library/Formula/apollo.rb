require 'formula'

class Apollo < Formula
  url 'http://www.apache.org/dist/activemq/activemq-apollo/1.0-beta3/apache-apollo-1.0-beta3-unix-distro.tar.gz'
  homepage 'http://activemq.apache.org/apollo'
  md5 'c77b7c9a45862c49d436009dc9c8124c'
  version "1.0-beta3"
  
  depends_on 'berkeley-db-je' # => :optional

  def install
    prefix.install %w{ LICENSE NOTICE readme.html docs examples }
    libexec.install Dir['*']
    
    have_je = false
    je_jar = `brew list berkeley-db-je`
    if $?.exitstatus == 0 
      have_je = true
      ln_s je_jar.rstrip, libexec+"lib"
    end
    
    (bin+'apollo').write bin_script('apollo')
    
    if ! File.exists?("#{var}/apollo")
      ohai 'creating the broker instance...'
      `sh #{bin}/apollo create #{var}/apollo`
      
      if have_je 
        inreplace "#{var}/apollo/etc/apollo.xml" do |s|
          s.gsub! "jdbm2_store", "bdb_store"
        end        
      end
    end
    
    (prefix+'org.apache.activemq.apollo.plist').write startup_plist

  end
  
  def bin_script(name)
    <<-EOS
#!/bin/bash
exec #{libexec}/bin/#{name} $@
EOS
  end
  
  def caveats
    <<-EOS

If this is your first install, automatically load on startup with:
    sudo cp #{prefix}/org.apache.activemq.apollo.plist /System/Library/LaunchDaemons/
    sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.activemq.apollo.plist

If this is an upgrade and you already have the org.apache.activemq.apollo.plist loaded:
    sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.activemq.apollo.plist
    sudo cp #{prefix}/org.apache.activemq.apollo.plist /System/Library/LaunchDaemons/
    sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.activemq.apollo.plist

Or start manually with:
    sudo #{var}/apollo/bin/apollo-broker run

EOS
  end

  def startup_plist
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>org.apache.activemq.apollo</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{var}/apollo/bin/apollo-broker</string>
      <string>run</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>WorkingDirectory</key>
    <string>#{var}/apollo</string>
  </dict>
</plist>
EOS
  end
    
end
