class Mockserver < Formula
  homepage "http://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/3.9.15/mockserver-netty-3.9.15-brew-tar.tar"
  version "3.9.15"
  sha256 "0dbe6e78c3753c1da0381322ec0d348c2a3a02783fd65bf280a7bfaff02046d7"

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
