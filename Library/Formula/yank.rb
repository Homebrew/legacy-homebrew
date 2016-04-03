class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.6.4.tar.gz"
  sha256 "4794bd1e5eba2358b63253e750c547a2791e663105d91b18cd4818e0a534e75f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdfd02eed19486e67fc61c91d7ecb5c0886aaa4fa84fb567986688f3fec061ab" => :el_capitan
    sha256 "eedc2cfbfce32218d9448600afe50043dcb7d5264e2fe97463b19dd3b03c27ef" => :yosemite
    sha256 "d3b4110d3c3a5f0d8d700beae731e4aa27114282dc786c1763a21bc0ccfada61" => :mavericks
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
