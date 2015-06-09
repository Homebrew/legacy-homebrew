class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.74.tar.gz"
  sha256 "1341af6864643a968d85bfa63ca231604b6d1123919c6826ae179908c6c4a176"
  head "https://github.com/xyproto/algernon.git"

  depends_on "go" => :build
  depends_on :hg => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath

    system "go", "get", "-d"
    system "go", "build", "-o", "algernon"

    bin.install "algernon"
  end

  test do
    begin
      tempdb = "/tmp/_brew_test.db"
      cport = ":45678"

      # Start the server in a detached process
      fork_pid = fork do
        `#{bin}/algernon --httponly --server --addr #{cport} --boltdb #{tempdb}`
      end
      child_pid = fork_pid + 1
      Process.detach fork_pid

      # Wait for the server to start serving
      sleep(0.5)

      # Check that we have the right PID
      pgrep_output = `pgrep algernon`
      assert_equal 1, pgrep_output.count("\n")
      assert_equal pgrep_output.to_i, child_pid
      algernon_pid = child_pid

      # Check that the server is responding correctly
      output = `curl -sIm3 -o- http://localhost#{cport}`
      assert output.include?("Server: Algernon")
      assert_equal 0, $?.exitstatus
    ensure
      # Stop the server gracefully
      Process.kill("HUP", algernon_pid)

      # Remove temporary Bolt database
      `rm -f #{tempdb}`
    end
  end
end
