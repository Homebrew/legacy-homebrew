class Connect < Formula
  desc "provides SOCKS and HTTPS proxy support to SSH."
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.105.tar.gz"
  sha256 "e7c98d31787f93b51c62ee05e0b558cfb577cda8198834a6d5b4d32528bf63ee"

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
