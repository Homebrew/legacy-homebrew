require 'formula'

class Apollo < Formula
  version "1.0"
  url "http://archive.apache.org/dist/activemq/activemq-apollo/#{version}/apache-apollo-#{version}-unix-distro.tar.gz"
  homepage 'http://activemq.apache.org/apollo'
  md5 '7388ff240b48acabcd6ec6859dbbbff6'
  
  depends_on 'berkeley-db-je' => :optional

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
      ohai "creating the broker instance '#{var}/apollo' ..."
      `sh #{bin}/apollo create #{var}/apollo`
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
    if File.exists?("#{var}/apollo/log/apollo.log")
      """
You have an existing broker instance located at: #{var}/apollo
You may need to updated update the #{var}/apollo/bin/apollo-broker script to use the new broker version.
"""
    else
      ""
    end +"""
To automatically load on startup, run:
    sudo cp #{prefix}/org.apache.activemq.apollo.plist /System/Library/LaunchDaemons/
    sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.activemq.apollo.plist

Or to start the broker in the foreground run:
    sudo #{var}/apollo/bin/apollo-broker run
    
"""
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
