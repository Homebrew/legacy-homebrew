class Mockserver < Formula
  homepage "http://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/3.9.15/mockserver-netty-3.9.15-brew-tar.tar"
  version "3.9.15"
  sha256 "0dbe6e78c3753c1da0381322ec0d348c2a3a02783fd65bf280a7bfaff02046d7"

  depends_on :java => "1.6+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/run_mockserver.sh" => "mockserver"

    # add lib directory soft link
    lib.install_symlink "#{libexec}/lib" => "mockserver"

    # add log directory soft link
    mockserver_log = var/"log"/"mockserver"
    mockserver_log.mkpath

    libexec.install_symlink mockserver_log => "log"
  end

  def test
    require "socket"

    # dynamically find free port
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    # start MockServer
    mockserver = fork do
      exec "#{bin}/mockserver", "-serverPort", port.to_s
    end

    # check its started up correctly
    begin 
      `#{"curl -s \"http://localhost:" + port.to_s + "/status\" -X PUT"}`
    end while $?.exitstatus != 0

    # shut it down
    system "curl -s \"http://localhost:" + port.to_s + "/stop\" -X PUT"

    # wait for MockServer to stop
    Process.wait(mockserver)
  end
end