require "formula"

class Fibjs < Formula
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/archive/v0.1.1.tar.gz"
  sha1 "59b819ee4d22b2a339f3bfc0dff115a5d8452256"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha1 "5c9dee229c3c5eede978eabe3ec6ccc5b7c4a616" => :yosemite
    sha1 "9eb15e12ad700529ad91bf0f294d349474dc7144" => :mavericks
    sha1 "11120148b4943383ddd8779c6a4d18dba72735eb" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "./build", "Release", "-j#{ENV["HOMEBREW_MAKE_JOBS"]}"
    bin.install "bin/Darwin_Release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/fibjs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
