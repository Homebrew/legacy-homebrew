class TokyoTyrant < Formula
  desc "Lightweight database server"
  homepage "http://fallabs.com/tokyotyrant/"
  url "http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz"
  sha256 "42af70fb9f2795d4e05c3e37941ce392a9eaafc991e230c48115370f6d64b88f"
  revision 1

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{libexec}"
    system "make"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    pid = fork do
      exec "#{bin}/ttserver -port 8081"
    end
    sleep 2

    begin
      # "Not Found" here means we've not setup a database, but server is running.
      assert_match "Not Found", shell_output("curl localhost:8081")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
