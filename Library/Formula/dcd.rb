class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.7.0",
      :revision => "5310b346304e060c7633521fe3fd5afc2a16de88"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "4c374caea3609ac4852a5aac8ee12c0949d1c7cd856740c2d1f639befa386259" => :yosemite
    sha256 "b30a4329fb2c3cb80c18f0ff1c4691037832cd995cc7f8a371f97019f9d9dce5" => :mavericks
    sha256 "9367b7f6fced915d49a20e9ec30ba399a3ad827096aea7ade765e0028eae6c51" => :mountain_lion
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    begin
      # spawn a server, using a non-default port to avoid
      # clashes with pre-existing dcd-server instances
      server = fork do
        exec "#{bin}/dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "#{bin}/dcd-client", "-q", "-p9167"
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
