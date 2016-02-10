class Httptunnel < Formula
  desc "Tunnels a data stream in HTTP requests"
  homepage "https://github.com/larsbrinkhoff/httptunnel"
  url "http://ftpmirror.gnu.org/httptunnel/httptunnel-3.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/httptunnel/httptunnel-3.3.tar.gz"
  sha256 "142f82b204876c2aa90f19193c7ff78d90bb4c2cba99dfd4ef625864aed1c556"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/hts --stdin-stdout --pid-file #{testpath}/pid 8081"
    end
    sleep 2

    begin
      assert File.exist?("#{testpath}/pid")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
