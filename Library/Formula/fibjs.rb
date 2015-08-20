class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.5/fibjs-0.1.5-fullsrc.zip"
  sha256 "ef9484c743446581a4f0aa34fe1cc520d80b70a3218fbbe4dfcfe292756e340f"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha256 "a62f8e9735d61f8dc73781be5ff2997caa84386c227835cb2945ef5b6b58419b" => :yosemite
    sha256 "511407e14bc400b1c2bd40840537245a5267b99a1473c6c0e2cd71760163aac3" => :mavericks
    sha256 "0bc350e4824213e4f4652f834b5954d7c2e87820b563eef2d9242bc2e7a47681" => :mountain_lion
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
