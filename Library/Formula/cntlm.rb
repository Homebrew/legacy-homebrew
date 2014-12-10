require 'formula'

class Cntlm < Formula
  homepage 'http://cntlm.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.bz2'
  sha1 '9b68a687218dd202c04b678ba8c559edba6f6f7b'

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "SYSCONFDIR=#{etc}"
    # install target fails - @adamv
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/cntlm</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
