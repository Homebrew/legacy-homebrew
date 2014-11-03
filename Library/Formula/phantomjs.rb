require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"

  stable do
    url "https://github.com/ariya/phantomjs/archive/1.9.8.tar.gz"
    sha256 "3a321561677f678ca00137c47689e3379c7fe6b83f7597d2d5de187dd243f7be"
  end

  bottle do
    cellar :any
    sha1 "d7016751675b1b7948e712b7c90e38f698527ae7" => :yosemite
    sha1 "cb2da81b59d7b5825645d4a598876539a99bf65c" => :mavericks
    sha1 "c43984e9ffb64d628f27b64bae5b75cbfd9dcfc2" => :mountain_lion
  end

  head "https://github.com/ariya/phantomjs.git"

  depends_on "openssl"

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
