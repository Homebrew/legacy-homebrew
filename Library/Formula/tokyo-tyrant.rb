class TokyoTyrant < Formula
  desc "Lightweight database server"
  homepage "http://fallabs.com/tokyotyrant/"
  url "http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz"
  sha256 "42af70fb9f2795d4e05c3e37941ce392a9eaafc991e230c48115370f6d64b88f"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "86b6cffac71df0a8e49ccfe105a1660575f0172724e5cf022085b3619188e195" => :el_capitan
    sha256 "679aa39858e5e5d6d10eada454fccc94bee805c82c31f65976646110776df758" => :yosemite
    sha256 "9454373c1a0cbfe78e3347341fbf0203fb3284023df5e68b3a49939c9c55bf64" => :mavericks
  end

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{libexec}"
    system "make"
    system "make", "install", "PCDIR=#{lib}/pkgconfig"
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
