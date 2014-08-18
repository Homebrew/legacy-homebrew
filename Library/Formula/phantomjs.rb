require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"

  stable do
    url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-source.zip"
    sha1 "124b017d493d5ccabd22afaf078d0650ac048840"

    patch do
      url "https://github.com/ariya/phantomjs/commit/fe6a96.diff"
      sha1 "d3efd38e0f3f0da08530d0bf603ea72ebdf06b78"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha1 "3f775a08beeee3c2ec1f491b9621e1ec93ace92a" => :mavericks
    sha1 "e3a2b1e5a77afea0b3d8913dfa3f791eee3aab9c" => :mountain_lion
    sha1 "273dbe33d1edbdd034c903d919278d33d7ebe5dd" => :lion
  end

  head do
    url "https://github.com/ariya/phantomjs.git"
  end

  def install
    if build.stable? && MacOS.prefer_64_bit?
      inreplace "src/qt/preconfig.sh", "-arch x86", "-arch x86_64"
    end
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

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
