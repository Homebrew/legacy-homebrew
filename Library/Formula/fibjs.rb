class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/xicilion/fibjs/releases/download/v0.2.0/fullsrc.zip"
  version "0.2.0"
  sha256 "db79df72f4e46e23f1ee3c0c21c5e265ee1fd6ccf841a6cf544b1fa7241713c5"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "582616a3f4eb28d8b0153890f504af2b7b6feb2e35c5b035e12110d08edf8d97" => :el_capitan
    sha256 "97832036fe7302f20c3a2ce04b543fdb38283818d45fd19a497549a4d361585a" => :yosemite
    sha256 "e28aee6fbd4f4a6475dcd720784bd9ca45a77f77674a9432c67b6ede84560d8b" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "./build", "Release", "-j#{ENV.make_jobs}"
    bin.install "bin/Darwin_Release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
