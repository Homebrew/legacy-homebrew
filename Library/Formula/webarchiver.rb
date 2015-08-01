class Webarchiver < Formula
  desc "allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.9.tar.gz"
  sha256 "8ea826038e923c72e75a4bbb1416910368140a675421f6aaa51fd0dea703f75c"
  head "https://github.com/newzealandpaul/webarchiver.git"

  bottle do
    cellar :any
    sha256 "829859d0f3fd2f52d1d611c74f3678f5e078f0af519a60ac334da09947cdc99f" => :yosemite
    sha256 "a599a339bc07e0b464b3255ebae4d23d8bd221787069a755d7bbb52d2aefe778" => :mavericks
  end

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
