class Redir < Formula
  desc "Port redirector"
  homepage "http://sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  version "2.2.1-9"
  sha256 "7e6612a0eee1626a0e7d9888de49b9c0fa4b7f75c5c4caca7804bf73d73f01fe"

  bottle do
    cellar :any
    sha256 "76c6d218033c27de7a5030e8d9fe1356e0a152e3a31e4210b589314643b9fd0d" => :yosemite
    sha256 "19b1d25bc23f38eeecd22c9ed2eac4640e63e97d7a192e7bc71b822d5d29afe0" => :mavericks
    sha256 "7b363f804ba92db19815e67697fa28247fe346be4733c48b9b306e2797a3344b" => :mountain_lion
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
