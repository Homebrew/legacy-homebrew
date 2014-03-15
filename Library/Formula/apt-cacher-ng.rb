require 'formula'

class AptCacherNg < Formula
  homepage 'http://www.unix-ag.uni-kl.de/~bloch/acng/'
  url 'http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.7.25.orig.tar.xz'
  sha1 'b4a3330be383af3b4edffc89641904908e2934de'

  depends_on 'cmake' => :build
  depends_on 'osxfuse' => :build
  depends_on 'boost' => :build

  def install
    system 'make apt-cacher-ng'

    inreplace 'conf/acng.conf' do |s|
      s.gsub! /^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng"
      s.gsub! /^LogDir: .*/, "LogDir: #{var}/log"
    end

    # copy default config over
    etc.install 'conf' => 'apt-cacher-ng'

    # create the cache directory
    (var/'spool/apt-cacher-ng').mkpath
    (var/'log').mkpath

    sbin.install 'build/apt-cacher-ng'
    man8.install 'doc/man/apt-cacher-ng.8'
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/apt-cacher-ng</string>
        <string>-c</string>
        <string>#{etc}/apt-cacher-ng</string>
        <string>foreground=1</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

end
