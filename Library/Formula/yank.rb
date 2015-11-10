class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.4.1.tar.gz"
  sha256 "cbd6b3c9d580fa619f3cba2c53b18d26674d587333976fe75b402f76ea01c4e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "310f46a6d042d720424fcb43e40cc71aaa2c4d10f9e221f8229fb68da20939f9" => :el_capitan
    sha256 "2f820af12a2af1495f42b92f43f60fbfe25e77740d83f98fe5a3c182afb33a91" => :yosemite
    sha256 "02b0f0c04a68d1875b39a8651520b23fa762705f24e2302b4bfa6f72603e93ad" => :mavericks
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
