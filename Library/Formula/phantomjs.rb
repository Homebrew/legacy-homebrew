require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"

  stable do
    url "https://github.com/ariya/phantomjs/archive/2.0.0.tar.gz"
    sha256 "0a1338464ca37314037d139b3e0f7368325f5d8810628d9d9f2df9f9f535d407"
  end

  bottle do
    cellar :any
    sha1 "d7016751675b1b7948e712b7c90e38f698527ae7" => :yosemite
    sha1 "cb2da81b59d7b5825645d4a598876539a99bf65c" => :mavericks
    sha1 "c43984e9ffb64d628f27b64bae5b75cbfd9dcfc2" => :mountain_lion
  end

  # Qt Yosemite build fix. Upstream commit/PR:
  # https://qt.gitorious.org/qt/qtbase/commit/70e442
  # https://github.com/ariya/phantomjs/pull/12934
  patch do
    url "https://gist.githubusercontent.com/mikemcquaid/db645f7cbeec4f3b1b2e/raw/e664ecc5c259344d5a73a84b52e472bf8ad3733e/phantomjs-yosemite.patch"
    sha1 "1e723f055ef5df9a2945cbce3e70322105313f47"
  end

  head "https://github.com/ariya/phantomjs.git"

  depends_on "openssl"

  def install
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
