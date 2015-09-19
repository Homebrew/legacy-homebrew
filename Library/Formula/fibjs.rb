class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.6/fibjs-0.1.6-fullsrc.zip"
  sha256 "e942f2ace2699700920c0b58d53c0a8f567f83d6af1085cb4249fd77c40cf18c"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90478eefe0641005d80c50be08d8ea39d8819a3888e6af78a9b7bf15fe6ea50d" => :el_capitan
    sha256 "4e2f954c4f7fb7bbaba8625c4694532ea1f40d53d5a98e42900111e7eb127b0a" => :yosemite
    sha256 "5c5947ed6acb5ef82e10dc29ec758cf85e3711afdb617f846ca69c6319584f55" => :mavericks
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
