class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "http://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/3.9.16/mockserver-netty-3.9.16-brew-tar.tar"
  version "3.9.16"
  sha256 "60138b28e04ffb2eac2d4413f3c5e906e04233bc42b92210679c21a67a7cd1a8"

  bottle do
    cellar :any
    sha256 "7863dee35cd11f9825d6b14c4e7b09c220ac3c2bbb8387c430df046b80b21482" => :yosemite
    sha256 "c498debd91b33632811c6fafe761563172f97ddf904a69360ce6335e4a714713" => :mavericks
    sha256 "df557bf66af8ceead30cf1fc1948e993d04baf7be85a832db28f6b86b4150ddb" => :mountain_lion
  end

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
