class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://github.com/ariya/phantomjs.git",
      :tag => "2.1.1",
      :revision => "d9cda3dcd26b0e463533c5cc96e39c0f39fc32c1"
  head "https://github.com/ariya/phantomjs.git"

  bottle do
    cellar :any
    sha256 "f66255cd772834de297a10fc7053800bfbd99c4833196958c18f05299dec6bc9" => :el_capitan
    sha256 "0ba4152cce3869cc01ed697d9bbf4dfe55d7749693dfbf6bede24c191c0f177f" => :yosemite
    sha256 "908cacf9af85893f54c5330987099896448c2699a7f3712de3e2232348c433b2" => :mavericks
  end

  depends_on "openssl"

  def install
    inreplace "build.py", "/usr/local", HOMEBREW_PREFIX
    system "./build.py", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    pkgshare.install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
