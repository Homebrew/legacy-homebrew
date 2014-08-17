require "formula"

class Dockutil < Formula
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.0.tar.gz"
  sha1 "8b027a0b1559f12a1c97b4a0bfcadd1566d6e6ba"

  bottle do
    cellar :any
    sha1 "ba91d3ab1b64a8a4fd79bde869ecad702793e932" => :mavericks
    sha1 "de9c71e038429756b4505779bd3f48e13e7384e8" => :mountain_lion
    sha1 "9696ba0475e52f0969af8dd202290adfee28dc6a" => :lion
  end

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
    assert_equal "2.0.0", shell_output("#{bin}/dockutil --version").strip
  end
end
