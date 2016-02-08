class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/xicilion/fibjs/releases/download/v0.2.0/fullsrc.zip"
  version "0.2.0"
  sha256 "db79df72f4e46e23f1ee3c0c21c5e265ee1fd6ccf841a6cf544b1fa7241713c5"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9933122c47ad24ae0b7ee05e5bd767b417d94de27adb4f4e9bbd695fde7e2795" => :el_capitan
    sha256 "fb2f32249eac5ed002eab533d7cacae7af578544d06497baaf573d4493d275a1" => :yosemite
    sha256 "dd613776c5fe0bf2719ebfa910a39cdd23c94eb3d9deeafc90deefb158604fc2" => :mavericks
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
