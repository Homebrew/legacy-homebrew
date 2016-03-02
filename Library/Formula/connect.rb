class Connect < Formula
  desc "provides SOCKS and HTTPS proxy support to SSH."
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.104.tar.gz"
  sha256 "6ca5291ea8e4a402d875a5507ac78d635373584fd1912f2838b93e03b99730c8"

  def install
    # gcc will produce warnings but the application will work as expected
    system ENV.cc, "connect.c", "-o", "connect", "-lresolv"
    bin.install "connect"
  end

  test do
    # A poor test but a good test would require user configuration
    system "connect"
  end
end
