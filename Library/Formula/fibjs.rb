require "formula"

class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/archive/v0.1.2.tar.gz"
  sha1 "d19dc40fecfd1ee9cd6cc850d9c83267dc0f7a96"

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
