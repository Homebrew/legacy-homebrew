class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.0.3.tar.gz"
  sha256 "331edd529df1904bcbcfb43029ced7e2dafe1744841e74cd9fc9f440b8301085"
  head "https://github.com/robertdavidgraham/masscan.git"

  def install
    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert `#{bin}/masscan --echo`.include? "adapter ="
  end
end
