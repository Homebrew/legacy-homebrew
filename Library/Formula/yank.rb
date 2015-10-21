class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.4.1.tar.gz"
  sha256 "cbd6b3c9d580fa619f3cba2c53b18d26674d587333976fe75b402f76ea01c4e5"

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      #!/usr/bin/expect -f
      spawn sh
      set timeout 1
      send "echo key=value | yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    (testpath/"test").chmod 0755
    system "./test"
  end
end
