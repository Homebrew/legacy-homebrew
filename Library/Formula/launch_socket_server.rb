class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/sstephenson/launch_socket_server"
  url "https://github.com/sstephenson/launch_socket_server/archive/v1.0.0.tar.gz"
  sha256 "77b7eebf54a1f0e0ce250b3cf3fa19eb6bee6cb6d70989a9b6cd5b6a95695608"

  head "https://github.com/sstephenson/launch_socket_server.git"

  depends_on "go" => :build

  def install
    system "make"

    sbin.install "sbin/launch_socket_server"
    (libexec/"launch_socket_server").install "libexec/launch_socket_server/login_wrapper"
  end

  test do
    assert_match /usage/, shell_output("#{sbin}/launch_socket_server")
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/launch_socket_server</string>
          <string>/usr/local/bin/myserver</string>
          <string>argument1</string>
          <string>argument2</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>Socket</key>
          <dict>
            <key>SockNodeName</key>
            <string>0.0.0.0</string>
            <key>SockServiceName</key>
            <string>80</string>
          </dict>
        </dict>
        <key>EnvironmentVariables</key>
        <dict>
          <!--<key>LAUNCH_PROGRAM_SOCKET_PATH</key>-->
          <!--<string>/tmp/myserver.sock</string>-->
          <!--<key>LAUNCH_PROGRAM_TCP_ADDRESS</key>-->
          <!--<string>127.0.0.1:8000</string>-->
        </dict>
        <key>StandardErrorPath</key>
        <string>#{var}/log/launch_socket_server.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/launch_socket_server.log</string>
      </dict>
    </plist>
    EOS
  end
end
