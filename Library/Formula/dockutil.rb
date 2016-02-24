class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.2.tar.gz"
  sha256 "7d7a546adb825b0fba3f13d2dfc0cc08f2f3f6935c8bfa05c396bcc6e5df56b3"

  bottle :unneeded

  def install
    bin.install "scripts/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
