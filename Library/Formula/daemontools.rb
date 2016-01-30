class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"

  bottle do
    cellar :any
    sha256 "76b0d6f7594ee7283cd9f03d081d2b05091d9e955c8a5742b3d4f182b560ec63" => :yosemite
    sha256 "36deeab31e18b85393d47feb9f426c352a348796985c3a1e84ad2ceb658999e1" => :mavericks
    sha256 "a4b87a1af9856c1287a822b630f045b64466e074135144eb4aaf3039a5af92c1" => :mountain_lion
  end

  def install
    cd "daemontools-#{version}" do
      system "package/compile"
      bin.install Dir["command/*"]
    end
  end

  test do
    assert_match /Homebrew/, shell_output("#{bin}/softlimit -t 1 echo 'Homebrew'")
  end
end
