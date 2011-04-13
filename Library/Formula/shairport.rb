require 'formula'

class Shairport < Formula
  url 'git://github.com/albertz/shairport.git', :using => :git, :tag => 'c4987fb624023c6f833ff911829297c0a906a1d2'
  version '20110417'
  head 'git://github.com/albertz/shairport.git'
  homepage 'https://github.com/albertz/shairport'

  depends_on 'pkg-config'
  depends_on 'libao'
  depends_on 'IO::Socket::INET6' => :perl
  depends_on 'Crypt::OpenSSL::RSA' => :perl

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/#{target} $*
    EOS
  end

  def install
    system "make"
    libexec.install ['shairport.pl','hairtunes']
    (bin+'shairport').write shim_script('shairport.pl')
    (prefix+'org.mafipulation.shairport.plist').write startup_plist
  end

  def caveats
    <<-EOS.undent
    One of the dependencies, Crypt::OpenSSL::RSA, can't be compiled as a
    universal binary.

    To fix:

        export ARCHFLAGS="-arch x86_64" (replace x86_64 by your arch)
        perl -MCPAN -e 'install Crypt::OpenSSL::RSA'

    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.mafipulation.shairport.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mafipulation.shairport.plist

    If this is an upgrade and you already have the org.mafipulation.shairport.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.mafipulation.shairport.plist
        cp #{prefix}/org.mafipulation.shairport.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mafipulation.shairport.plist

    To start manually:
        shairport
        shairport --apname foo
    EOS
  end

  def startup_plist
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>org.mafipulation.shairport</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/shairport</string>
            <string>--apname</string>
            <string>#{`hostname`.chomp}</string>
        </array>
    </dict>
    </plist>
    EOS
  end

end