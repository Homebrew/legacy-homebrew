class Whereami < Formula
  homepage "http://victor.github.io/whereami/"
  url "https://github.com/victor/whereami/archive/v1.0.tar.gz"
  sha1 "2f81e4b05af5f6806590d7212c0dbfbea00a75e0"

  depends_on :xcode => ["6.1.1", :build]
  depends_on :macos => :yosemite

  def install
    system "xcodebuild", "install", "DSTROOT=#{prefix}", "INSTALL_PATH=/bin"
  end

  test do
    system "whereami", "--version"
  end
end
