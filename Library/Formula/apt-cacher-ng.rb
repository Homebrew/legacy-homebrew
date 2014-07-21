require 'formula'

class AptCacherNg < Formula
  homepage 'http://www.unix-ag.uni-kl.de/~bloch/acng/'
  url 'http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.7.26.orig.tar.xz'
  sha1 'ae8443c2ec277e81051d72d347e4e509a9253c34'

  bottle do
    sha1 "d39ad61b3354c2fc79ca95ff0568c7e9b0f16b31" => :mavericks
    sha1 "887012993dfa5feffbaf2459c01e8d64683363b9" => :mountain_lion
    sha1 "ce039104b43fa9c3b24b071479546184f4c2bc5e" => :lion
  end

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
