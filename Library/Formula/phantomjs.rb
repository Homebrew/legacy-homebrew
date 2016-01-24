class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  url "https://github.com/ariya/phantomjs.git",
      :tag => "2.1.0",
      :revision => "292358499e1ac66503a2639a76aeb155aa44ef73"
  head "https://github.com/ariya/phantomjs.git"

  bottle do
    cellar :any
    sha256 "8c1e531d9d6f06a1c8cfd1a8b58de013c67311a63b7ef7527a74c94c96bd1a5b" => :el_capitan
    sha256 "6d70d6aa35b60f8ae26ac7a40c41ab0cb7e70a55b07abac6d236545116b83822" => :yosemite
    sha256 "8712122649fa42ca342fa98a4588dac3402f7038e11540e541e6dc80193cbe82" => :mavericks
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
