require "formula"

class Dockutil < Formula
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.0.tar.gz"
  sha1 "8b027a0b1559f12a1c97b4a0bfcadd1566d6e6ba"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "plistlib" do
    url "https://pypi.python.org/packages/source/p/plist/plist-0.2.tar.gz"
    sha1 "eac8a0d71a20515f955101429101b3b9f445f809"
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'

    resource("plistlib").stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }

    bin.install "scripts/dockutil"
  end

  test do
    assert_equal "2.0.0", `#{bin}/dockutil --version`.strip
  end
end
