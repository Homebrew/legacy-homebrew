class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.5/fibjs-0.1.5-fullsrc.zip"
  sha256 "ef9484c743446581a4f0aa34fe1cc520d80b70a3218fbbe4dfcfe292756e340f"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha256 "41f6eeb1f5f81f6d151647c3cbe01358a6d099dacf05e245b2317ff1a722faa8" => :yosemite
    sha256 "e298976f55cc51c772da3d256867d1f071199b09c906ead9eeb3613da938d7dd" => :mavericks
    sha256 "fec11a40de8afdecda385fefb6cb96763522c895cc01a18d3e796b48f9584fca" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "./build", "Release", "-j#{ENV.make_jobs}"
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
