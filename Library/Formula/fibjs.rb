class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org"
  url "https://github.com/xicilion/fibjs/releases/download/v0.1.7/fibjs-0.1.7-fullsrc.zip"
  sha256 "e99b8453f8a79170cc73c2d221e8b2c425f4339615f3e1557d6f7cb7336e527e"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6d49a3aa6b7e1b88d290c85d9086b405dcbab72313813e03a9d87357c6a4184" => :el_capitan
    sha256 "dc181a83dc50c2efcc3cf7f1709cbd6a8e38c5a9b6fd91c72b575c293c89720c" => :yosemite
    sha256 "129301b93479765b5c802bd051cf2b2fc9ecba04533c7d6df9db2210e7a14bad" => :mavericks
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
