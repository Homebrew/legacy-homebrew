require "formula"

class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.3/fibjs-0.1.3-fullsrc.zip"
  sha256 "e9c94d41cd2f9c0cd773f6076270848961d27c01f1f77dd0f41beb408529c046"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any
    sha1 "055349bc97bd548fbde2819e3361131fed609e22" => :yosemite
    sha1 "3b80e72eccff9e45cec662b9506aa3875beeaf67" => :mavericks
    sha1 "27ab582d18228f794ef3460f7ee60fdce804fb0a" => :mountain_lion
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
