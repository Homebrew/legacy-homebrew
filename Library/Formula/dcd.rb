class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.6.0",
      :revision => "633b1667ef223e6eda7bcfd2d2d746f59036571f"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "b2bfea971d1cce8f221a524d3ddd10f5b2e6775acfe29754d765785d875a6bb6" => :yosemite
    sha256 "f159386dfbfb7d225010f3fa24e9b0dc911a718bd81a059be243edb6af4f880c" => :mavericks
    sha256 "84a24c63e3b05ce812ffb7453f1fd5edfb47dfe053bd6c02401f264dd9febc60" => :mountain_lion
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
        :tag => "v0.7.0-rc1",
        :revision => "70c78a2a109cd2cc83534f43350d24c879c41eaa"
    version "0.7.0-rc1"
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
