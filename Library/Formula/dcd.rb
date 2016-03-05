class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"

  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "aa5bf3b36f947743dcdf6d3cad4e2973ad2d08746a9eb668a5477b8458090110" => :el_capitan
    sha256 "fe742c126f957f99b1691b2044352f0b134bf0af8a1812c46b256a370f3396e7" => :yosemite
    sha256 "03cd0ece3ba032610457891fb74d1be87417a87e960377e38fc580df7ae8f2c1" => :mavericks
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.9.0-alpha1",
      :revision => "7028dc1fcfb7d409b413c243dd3403bb7a6fdc91"
    version "0.9.0-alpha1"
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
