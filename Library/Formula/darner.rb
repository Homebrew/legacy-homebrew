require 'formula'

class Darner < Formula
  homepage 'https://github.com/wavii/darner'
  url 'https://github.com/wavii/darner/archive/v0.2.0.tar.gz'
  sha1 '40858750ac82cd24dbb5ba77f409152feb6c2582'

  head 'https://github.com/wavii/darner.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'snappy'
  depends_on 'leveldb'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"

    (var/'darner').mkpath
    (var/'log/darner').mkpath
  end

  def caveats; <<-EOS.undent
    When started via launchd you'll find the darner log here:
        open #{var}/log/darner/darner.log
    EOS
  end

  plist_options :manual => "darner"

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_prefix}/bin/darner</string>
            <string>-d</string>
            <string>#{var}/darner</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/darner/darner.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/darner/darner.log</string>
        </dict>
      </plist>
    EOS
  end
end
