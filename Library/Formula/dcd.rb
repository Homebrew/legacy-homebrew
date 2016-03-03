class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "4b6835271045a2cebcb9729712e30b56eab55dd08ff38acb1106382c15092771" => :el_capitan
    sha256 "f3e08b029bdddeee54ccb243888516dc912af3c72accff0785f77be9ecf80239" => :yosemite
    sha256 "779c9f5801b4108efafadd225c15fce5e518c2766fb049f2f076b357c4cbe918" => :mavericks
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
