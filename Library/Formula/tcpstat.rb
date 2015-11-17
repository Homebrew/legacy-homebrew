class Tcpstat < Formula
  desc "Active TCP connections monitoring tool"
  homepage "https://github.com/jtt/tcpstat"
  url "https://github.com/jtt/tcpstat/archive/rel-0-1.tar.gz"
  version "0.1"
  sha256 "366a221950759015378775862a7499aaf727a3a9de67b15463b0991c2362fdaf"

  head "https://github.com/jtt/tcpstat.git"

  def install
    system "make"
    bin.install "tcpstat"
  end

  test do
    (testpath/"script.exp").write <<-EOS.undent
      set timeout 30
      spawn "#{bin}/tcpstat"
      send -- "q"
      expect eof
    EOS

    system "expect", "-f", "script.exp"
  end
end
