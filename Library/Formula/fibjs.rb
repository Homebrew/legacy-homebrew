class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.9/fullsrc.zip"
  version "0.1.9"
  sha256 "e7fb5b5513aa09bf36552a14bbd55b177612e085ecf52f95e84f901c830f8fd7"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80cbbfc5f3d9d8363a64a820901354aa854422cf1a2adaa6cdba9efb9cd758e8" => :el_capitan
    sha256 "0e1f3230c3eecc949082cc78bbcf7d716058a487aa24aa773437f2ee5947d9c5" => :yosemite
    sha256 "e98f75ad475496d0f16b90b7c66cbd4a800490ba51c1634a23eaacf923e0b477" => :mavericks
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
