class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.6.2.tar.gz"
  sha256 "e6dbeb1b8e5883f76156c2d3ff1b9a4171a6b59fabf5d38469e33d7719ffeb1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "108ab013dc85f6cea0dc45ec2753a6cb89d855354c6edcaaee4c4859b328a132" => :el_capitan
    sha256 "472e97039209d0490e517b4a16ca003c03eeca7ee819af3e0cf0feb4ba22a5a7" => :yosemite
    sha256 "e44007432eb1e51ccf430451d9f9123f0523b68ad2d84f1840c6f9b8646381d8" => :mavericks
  end

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
