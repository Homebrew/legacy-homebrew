class Webarchiver < Formula
  desc "allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.9.tar.gz"
  sha256 "8ea826038e923c72e75a4bbb1416910368140a675421f6aaa51fd0dea703f75c"
  head "https://github.com/newzealandpaul/webarchiver.git"

  depends_on :xcode => ["6.0.1", :build]

  def install
    xcodebuild
    bin.install "./build/Release/webarchiver"
  end

  test do
    system "webarchiver", "-url", "http://www.google.com", "-output", "foo.webarchive"
    assert_match /Apple binary property list/, shell_output("file foo.webarchive", 0)
  end
end
