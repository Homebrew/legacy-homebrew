class Connect < Formula
  desc "provides SOCKS and HTTPS proxy support to SSH."
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.105.tar.gz"
  sha256 "e7c98d31787f93b51c62ee05e0b558cfb577cda8198834a6d5b4d32528bf63ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "af244ce650bc1ebd50209b62d98c9780df9ff3b90b2b7496f7b74426f33349a6" => :el_capitan
    sha256 "1285bb995a9eed5ce5198da853bd33ce49c04ac0caa328b651be5d0421e784f4" => :yosemite
    sha256 "4f1dffe41e3164e12fe447c123e17a998cdc936d5dddb7cdc6195fb1b2293fcb" => :mavericks
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
