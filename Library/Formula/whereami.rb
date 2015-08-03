class Whereami < Formula
  desc "Provides user's current location from the command-line"
  homepage "https://victor.github.io/whereami/"
  url "https://github.com/victor/whereami/archive/v1.0.tar.gz"
  sha256 "75efa77897102e657ab6d23c97222dea4e7a2c9a1702664fd56506a7a187cf62"
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
