class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "http://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/3.9.17/mockserver-netty-3.9.17-brew-tar.tar"
  version "3.9.17"
  sha256 "7d7166b752aabeb65a13a66e0f70653d8fd880a72f1c8d80192d771dc63a9eb9"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/run_mockserver.sh" => "mockserver"

    lib.install_symlink "#{libexec}/lib" => "mockserver"

    mockserver_log = var/"log/mockserver"
    mockserver_log.mkpath

    libexec.install_symlink mockserver_log => "log"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    mockserver = fork do
      exec "#{bin}/mockserver", "-serverPort", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:" + port.to_s + "/status", "-X", "PUT")
      break if $?.exitstatus == 0
    end

    system "curl", "-s", "http://localhost:" + port.to_s + "/stop", "-X", "PUT"

    Process.wait(mockserver)
  end
end
