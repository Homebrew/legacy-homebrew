class TokyoTyrant < Formula
  desc "Lightweight database server"
  homepage "http://fallabs.com/tokyotyrant/"
  url "http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz"
  sha256 "42af70fb9f2795d4e05c3e37941ce392a9eaafc991e230c48115370f6d64b88f"
  revision 1

  bottle do
    cellar :any
    sha256 "57a41c1059c3b2d43f7fc8dfc1b3bae442ddf94a5cd2bb8e91015972ba45d483" => :el_capitan
    sha256 "faeb9efd37fbb0d163f541a3436c3ede81ebcd049094e172a03a0fc7a00e986a" => :yosemite
    sha256 "5d490b81052af030dcbdfd01b93bc6b8fdc37f52e9a561a62d631ce1fd67f902" => :mavericks
  end

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
