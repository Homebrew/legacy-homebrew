class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.6.4.tar.gz"
  sha256 "4794bd1e5eba2358b63253e750c547a2791e663105d91b18cd4818e0a534e75f"

  bottle do
    cellar :any_skip_relocation
    sha256 "16341bd1904ef0c2d4b5647479f8f53ec3b247d7afc0c7548367d11c855b395e" => :el_capitan
    sha256 "f2d04f91eb8d86f6bc2c59b7e902ac13b1f2bdff924ac6909cc4716ab89c454f" => :yosemite
    sha256 "bd47cbb68e38b6d1fdc2eccd0c9dcde31ec0c4ad9f2f0badbe39d201bf01498b" => :mavericks
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
