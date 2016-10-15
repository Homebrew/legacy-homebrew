require 'formula'

class Spread < Formula
  homepage 'http://www.spread.org'
  url 'ftp://ftp4.gwdg.de/pub/FreeBSD/ports/local-distfiles/ohauer/spread-src-4.2.0.tar.gz'
  mirror 'http://ftp.nsysu.edu.tw/FreeBSD/ports/local-distfiles/ohauer/spread-src-4.2.0.tar.gz'
  sha1 '6052d39610ec27e856d601310f5b7a7b982d02dc'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  def post_install
      (var+"spread").mkpath
  end

  def caveats; <<-EOS.undent
    A "/usr/local/etc/spread.conf" file exists. However, you must add an
    entry to the file for your hostname and primary IP address. Failure
    to do so will cause the program to abort with signal 6.
    EOS
  end

  plist_options :manual => "spread"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/D
TDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/spread</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    return if not Process.respond_to?(:spawn)
    master = Process.spawn("#{sbin}/spread -n localhost")
    sleep 2
    unless $?.exited?
      system "#{bin}/spflooder", "-m", "1", "-s", "4803@localhost"

      Process.kill("TERM", master)
      Process.wait master
    end
  end
end
