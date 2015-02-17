class Swiftrsrc < Formula
  homepage "https://github.com/indragiek/swiftrsrc"
  url "https://github.com/indragiek/swiftrsrc/archive/1.0.tar.gz"
  sha1 "7fd484e0710c776a294896d93a2ee66c63069018"

  depends_on :macos => :mavericks
  depends_on "carthage" => :build

  def install
    system "carthage", "checkout"
    system "xcodebuild", "DSTROOT=#{prefix}", "INSTALL_PATH=/bin", "install"
  end

  test do
    system "#{bin}/swiftrsrc"
  end
end
