class Disque < Formula
  homepage "https://github.com/antirez/disque"
  head "https://github.com/antirez/disque/archive/master.tar.gz", :branch => "master"

  def install
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    bin.install "src/disque"
    bin.install "src/disque-check-aof"
    bin.install "src/disque-server"

    %w[run db/disque log].each { |p| (var+p).mkpath }

    inreplace "disque.conf" do |s|
      s.gsub! "/var/run/disque.pid", "#{var}/run/disque.pid"
      s.gsub! "dir ./", "dir #{var}/db/disque"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
      # The `slave` and `pubsub` classes are not yet implemented at the time of writing of this Formula:
      #   <https://github.com/antirez/disque/blob/be8fa8acfad0e57c2a906df94925a55409050703/src/networking.c#L1426>
      # Otherwise running disque-server with those lines uncommented results in the following error:
      #   *** FATAL CONFIG FILE ERROR ***
      #   Reading the configuration file, at line 412
      #   >>> 'client-output-buffer-limit slave 256mb 64mb 60'
      s.gsub! "client-output-buffer-limit slave 256mb 64mb 60", "\# client-output-buffer-limit slave 256mb 64mb 60"
      s.gsub! "client-output-buffer-limit pubsub 32mb 8mb 60", "\# client-output-buffer-limit pubsub 32mb 8mb 60"
    end

    etc.install "disque.conf"
  end

  plist_options :manual => "disque-server #{HOMEBREW_PREFIX}/etc/disque.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/disque-server</string>
          <string>#{etc}/disque.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/disque.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/disque.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/disque-server", "--test-memory", "2"
  end
end
