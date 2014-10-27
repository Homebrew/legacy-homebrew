require "formula"

class Fibjs < Formula
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/archive/v0.1.0.tar.gz"
  sha1 "2e933da29ea66eee0a9ff8b604f9e3935c3b90fa"

  head "https://github.com/xicilion/fibjs.git"

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
