class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.7.3",
      :revision => "f8fc736663b8c5636b7651b462a383cd56d9a0f5"
  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    sha256 "3c07fa03ff586ae329e870e4bfa0252fead6e10f63842965395dec11f28e3108" => :el_capitan
    sha256 "ffacc9a44f364c98121f4fdc85409af97f740e806bab289b08f967bd95e40420" => :yosemite
    sha256 "415a4ab95f999a5a51fb978215334912917f9b4129ae8161882ee891bdac189e" => :mavericks
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
