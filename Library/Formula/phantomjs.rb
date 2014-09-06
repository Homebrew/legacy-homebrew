require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"
  revision 1

  stable do
    url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-source.zip"
    sha256 "0f6c50ff24c1c4a8ccd7fedef62feef5e45195c7ba5ef6c84434448544877ff3"

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

  head "https://github.com/ariya/phantomjs.git"

  depends_on 'openssl'

  def install
    if build.stable? && MacOS.prefer_64_bit?
      inreplace "src/qt/preconfig.sh", "-arch x86", "-arch x86_64"
    end
    system "./build.sh", "--confirm", "--jobs", ENV.make_jobs,
      "--qt-config", "-openssl-linked"
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
