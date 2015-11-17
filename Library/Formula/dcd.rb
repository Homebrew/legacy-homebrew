class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.7.2",
      :revision => "9a426aed473ad30b8cec2dd311823685b20ba049"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "d9f3dd8bcc37513fcd38c0af5f917eaed37a9023e7227841ebe87dd12dfb043f" => :el_capitan
    sha256 "5b7f897e87231411c075d02b3e44aea6f4fa318722043d87e9fb318a01d0f3a1" => :yosemite
    sha256 "2bc0a9076d02f20aaf8901c22907513c3d8fdde9f49adde673db400746d58398" => :mavericks
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
