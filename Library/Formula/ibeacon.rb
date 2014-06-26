require "formula"

class Ibeacon < Formula
  homepage "https://github.com/RadiusNetworks/ibeacon-cli"
  url "https://github.com/RadiusNetworks/ibeacon-cli/archive/v1.0.1.tar.gz"
  sha1 "2f2b635a1211950772c0ae5269b955c280b8fe73"
  head "https://github.com/RadiusNetworks/ibeacon-cli.git"

  bottle do
    cellar :any
    sha1 "5ef4660cbd0fdc96c7a9c0ad7a58f462a1a2a2d4" => :mavericks
  end

  depends_on :macos => :mavericks
  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build", "-verbose"
    prefix.install "build/Release/ibeacon"
    bin.write_exec_script "#{prefix}/ibeacon"
  end

  test do
    assert `#{bin}/ibeacon --version`.include?("Version")
  end
end
