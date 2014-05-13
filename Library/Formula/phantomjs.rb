require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"
  url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-source.zip"
  sha1 "124b017d493d5ccabd22afaf078d0650ac048840"

  bottle do
    cellar :any
    revision 1
    sha1 "3f775a08beeee3c2ec1f491b9621e1ec93ace92a" => :mavericks
    sha1 "e3a2b1e5a77afea0b3d8913dfa3f791eee3aab9c" => :mountain_lion
    sha1 "273dbe33d1edbdd034c903d919278d33d7ebe5dd" => :lion
  end

  patch do
    url "https://github.com/ariya/phantomjs/commit/fe6a96.diff"
    sha1 "d3efd38e0f3f0da08530d0bf603ea72ebdf06b78"
  end

  def install
    inreplace "src/qt/preconfig.sh", "-arch x86", "-arch x86_64" if MacOS.prefer_64_bit?
    system "./build.sh", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    (share+"phantomjs").install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    output = `#{bin}/phantomjs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
