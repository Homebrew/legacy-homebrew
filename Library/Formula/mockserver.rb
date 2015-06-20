class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "http://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/3.9.16/mockserver-netty-3.9.16-brew-tar.tar"
  version "3.9.16"
  sha256 "60138b28e04ffb2eac2d4413f3c5e906e04233bc42b92210679c21a67a7cd1a8"

  bottle do
    cellar :any
    sha256 "06500732332e945ded83457a81d68545f8434c7b9a3648e86c0f2219f9737f06" => :yosemite
    sha256 "be8520628c465c397c0f87f9373573a98cd4e176c66e8ef4319106464341230f" => :mavericks
    sha256 "1575d2991726bb2685b07dc7f1484b6a991644c68117c4ebeea060752e5c62ce" => :mountain_lion
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
