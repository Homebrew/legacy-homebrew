class Dcd < Formula
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.5.1",
      :revision => "351bf2ee2d5f1c4986c2c5957f542dda17b1d085"

  bottle do
    sha256 "7d1de0bae7b64fd4f53058e9213cd59a1d270f25284c5f2e4dad15767a57ce24" => :yosemite
    sha256 "c0fc2ee139512990048318d9e7677ae836f85a98ff56c9d3005434bf8c289159" => :mavericks
    sha256 "f8a494c721a1d3f4a45b802c3c90a2ea61a04de6345cb5d6c3fca44afb50f783" => :mountain_lion
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
