class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.2.tar.gz"
  sha256 "7d7a546adb825b0fba3f13d2dfc0cc08f2f3f6935c8bfa05c396bcc6e5df56b3"

  bottle do
    cellar :any
    sha1 "db8dc90ae8f1704f77c9ae25bdd6a760a3749eb3" => :yosemite
    sha1 "5e9f89f37f48c7871ed4fee7bd6f89656ce4a1cb" => :mavericks
    sha1 "31f4c3b4c8702ef36fa085db47b1335f64259875" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "plistlib" do
    url "https://pypi.python.org/packages/source/p/plist/plist-0.2.tar.gz"
    sha256 "531595d63ee4b7de6a168fc4ca715c475be9700de93455a7c73a176a1e1f3345"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resource("plistlib").stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }

    bin.install "scripts/dockutil"
  end

  test do
    assert_equal "2.0.2", shell_output("#{bin}/dockutil --version").strip
  end
end
