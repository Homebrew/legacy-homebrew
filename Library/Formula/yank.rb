class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.5.0.tar.gz"
  sha256 "237a8406130fda2f555ef2696e114ef508257743feb02865b21f62db43c52fa5"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b3af1fe58e5ae257370df1229577a18bde8eadc925fe3676560c6cd78f3a5d9" => :el_capitan
    sha256 "9a008ddf303dde9d3b44e69b76534245d34cf29ec768fd0aee2ef8df94a928a8" => :yosemite
    sha256 "523fa3f42ba361f22e1f65da4e04567501e2a54b38b00074ab79e9ce3870a03a" => :mavericks
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
