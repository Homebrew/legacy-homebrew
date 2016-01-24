class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://github.com/ariya/phantomjs.git",
      :tag => "2.1.0",
      :revision => "292358499e1ac66503a2639a76aeb155aa44ef73"
  head "https://github.com/ariya/phantomjs.git"

  bottle do
    cellar :any
    sha256 "49f74d6b91ec5e08b26b796f9bfb93c5f024d9c7178f1f3d2d9ef2bf213b3074" => :el_capitan
    sha256 "a0a1d7a0ead24f93f76a9f5ac67f361fc7ee98f258cbb9ecb5ec9c70b29e77b2" => :yosemite
    sha256 "154d86c1cffdf51c4bc121592b47da3e15a6a34e5f71053820a67238822a5cde" => :mavericks
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
