require "formula"

class Fibjs < Formula
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/archive/v0.1.1.tar.gz"
  sha1 "59b819ee4d22b2a339f3bfc0dff115a5d8452256"

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
