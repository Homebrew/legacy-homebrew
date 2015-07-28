require "formula"

class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.3/fibjs-0.1.3-fullsrc.zip"
  sha256 "e9c94d41cd2f9c0cd773f6076270848961d27c01f1f77dd0f41beb408529c046"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha256 "cdb2cbbf0b065071b6ed46fab8a459fcbfab7c1b040177379569ec95b0daac81" => :yosemite
    sha256 "895ef0a56a714deb0bcd03fb71a187a60b327da201332843e2c9ec80685088f0" => :mavericks
    sha256 "826885a9c7e34089cd99670fa7817a8f25d52d75129757581559579f95940571" => :mountain_lion
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
