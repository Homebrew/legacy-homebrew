require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class AptCacherNg < Formula
   homepage 'http://www.unix-ag.uni-kl.de/~bloch/acng/'
   url 'http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.7.12.orig.tar.xz'
   sha1 '5a31062a67aea1a40e9034cd453fcf8cb8abd59d'

   depends_on 'cmake' => :build

   def install
      system 'make'

      inreplace 'conf/acng.conf' do |s|
         s.gsub! /^CacheDir: .*/, 'CacheDir: /Library/Caches/apt-cacher-ng'
         s.gsub! /^LogDir: .*/, 'LogDir: ' + var + '/log'
      end

      # copy default config over
      (etc + '/apt-cacher-ng').mkpath
      cp_r 'conf',  etc/'apt-cacher-ng'

      # create the cache directory
      mkpath('/Library/Caches/apt-cacher-ng')

      sbin.install 'build/apt-cacher-ng'
      sbin.install 'build/acngfs'
      sbin.install 'build/in.acng'
      man8.install 'doc/man/apt-cacher-ng.8'
      man8.install 'doc/man/acngfs.8'
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
            <string>#{opt_prefix}/sbin/apt-cacher-ng</string>
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

