class Serveit < Formula
  desc "synchronous server and rebuilder of static content"
  homepage "https://github.com/garybernhardt/serveit"
  head "https://github.com/garybernhardt/serveit.git"

  depends_on :ruby => "1.9"

  def install
    bin.install "serveit"
  end

  test do
    begin
      pid = fork { exec bin/"serveit" }
      sleep 2
      assert_match /Listing for/, shell_output("curl localhost:8000")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
