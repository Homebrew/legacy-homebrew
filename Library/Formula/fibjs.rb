require "formula"

class Fibjs < Formula
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/archive/v0.1.0.tar.gz"
  sha1 "2e933da29ea66eee0a9ff8b604f9e3935c3b90fa"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha1 "2a21b1cf4aa39b1b8560087df1786c5aa4dd6fbc" => :yosemite
    sha1 "772f0f1b9059b5e7e1e9ca07714e8e60508518c4" => :mavericks
    sha1 "8cfa4d2b59ce2b401d8adc384583a4a040c50064" => :mountain_lion
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
