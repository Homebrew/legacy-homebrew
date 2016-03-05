class Connect < Formula
  desc "provides SOCKS and HTTPS proxy support to SSH."
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.104.tar.gz"
  sha256 "6ca5291ea8e4a402d875a5507ac78d635373584fd1912f2838b93e03b99730c8"

  def install
    # remove check for windows version that throws error
    inreplace "Makefile", "WINVER := $(shell ver)", ""
    # gcc will produce warnings but the application will work as expected
    system "make"
    bin.install "connect"
  end

  test do
    system "bin/connect"
  end
end
