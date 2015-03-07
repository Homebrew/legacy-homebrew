class Redir < Formula
  homepage "http://sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  version "2.2.1_9"
  sha1 "84ae75104d79432bbc15f67e4dc2980e0912b2b6"

  bottle do
    cellar :any
    sha1 "2a57028bcc1b6a0275e4f912848a107b3fb033b6" => :yosemite
    sha1 "e87c9be1628c1d54624be55f94f686f96b2b5d15" => :mavericks
    sha1 "e0fe4cd60535063295ad7527516d3ac114b5e72d" => :mountain_lion
  end

  def install
    system "make"
    bin.install "redir"
    man1.install "redir.man"
  end

  test do
    redir_pid = fork do
      exec "#{bin}/redir", "--cport=12345", "--lport=54321"
    end
    Process.detach(redir_pid)

    nc_pid = fork do
      exec "nc -l 12345"
    end

    # Give time to processes start
    sleep(1)

    begin
      # Check if the process is running
      system "kill", "-0", redir_pid

      # Check if the port redirect works
      system "nc", "-z", "localhost", "54321"
    ensure
      Process.kill("TERM", redir_pid)
      Process.kill("TERM", nc_pid)
      Process.wait(nc_pid)
    end
  end
end
