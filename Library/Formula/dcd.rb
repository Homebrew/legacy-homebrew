class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.7.5",
      :revision => "1f30d3872e4c5ace634d9b470dac24e993b16acc"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "c7154b82476d7d84cde1488e72c0eed2d7f17bb3e91ecfa4f6d3bd05edee536a" => :el_capitan
    sha256 "38084981f93dae823f7af73ec2a1fc4e0e24d11f941863bb99a08046b51103a5" => :yosemite
    sha256 "929f10cfbbf34c732c49cc4e158442597da526835b3315f0e63c88f2def9dab6" => :mavericks
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
