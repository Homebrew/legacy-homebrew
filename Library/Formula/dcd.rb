class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.6.0",
      :revision => "633b1667ef223e6eda7bcfd2d2d746f59036571f"

  bottle do
    sha256 "b2bfea971d1cce8f221a524d3ddd10f5b2e6775acfe29754d765785d875a6bb6" => :yosemite
    sha256 "f159386dfbfb7d225010f3fa24e9b0dc911a718bd81a059be243edb6af4f880c" => :mavericks
    sha256 "84a24c63e3b05ce812ffb7453f1fd5edfb47dfe053bd6c02401f264dd9febc60" => :mountain_lion
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
      puts "==> dcd-server -p9167"
      # would use spawn, can't on M-L as ruby 1.8
      server = fork do
        exec "dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "dcd-client", "-q", "-p9167"
    rescue
      if server
        # clean up the server process
        Process.kill "TERM", server
      end
      raise
    end
    # Ditto
    Process.kill "TERM", server
  end
end
