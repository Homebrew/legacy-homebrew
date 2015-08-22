class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "http://cr.yp.to/daemontools.html"
  url "http://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"

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
