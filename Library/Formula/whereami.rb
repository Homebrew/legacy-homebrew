class Whereami < Formula
  desc "Provides user's current location from the command-line"
  homepage "http://victor.github.io/whereami/"
  url "https://github.com/victor/whereami/archive/v1.0.tar.gz"
  sha1 "2f81e4b05af5f6806590d7212c0dbfbea00a75e0"
  head "https://github.com/victor/whereami.git", :branch => "swift"

  bottle do
    cellar :any
    sha1 "f1b35d4c5180a303169d0ba251daf39375c20065" => :yosemite
  end

  depends_on :xcode => ["6.1.1", :build]
  depends_on :macos => :yosemite

  def install
    xcodebuild "install", "DSTROOT=#{prefix}", "INSTALL_PATH=/bin"
  end

  test do
    system "whereami", "--version"
  end
end
