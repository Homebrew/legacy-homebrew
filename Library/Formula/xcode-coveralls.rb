class XcodeCoveralls < Formula
  desc "A tool to upload code coverage from Xcode to coveralls.io."
  homepage "https://macmade.github.io/xcode-coveralls"
  url "https://github.com/macmade/xcode-coveralls/archive/0.1.0.tar.gz"
  sha256 "17e671c39a2c037a40e5f35808744752c802d7884cd16f17bb247fa1bb337d59"
  depends_on :xcode => 6.0
  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/xcode-coveralls"
  end
  test do
    system "#{bin}/xcode-coveralls", "--version"
  end
end
