class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "64afdd71688797e0bfef29f8db63a82a13b514e30b52b32180c17f9d895fa07c" => :el_capitan
    sha256 "4a8fe9b0e5038230c90f2a38b40f3d66d103c18969e28ce5465499bbd78ec867" => :yosemite
    sha256 "75757ef94d879092ea4b82dd36c17336fb6a85eb1d5980e3f01c7bf2a140ec1b" => :mavericks
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
