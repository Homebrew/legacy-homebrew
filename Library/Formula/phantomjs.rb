require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"

  stable do
    url "https://github.com/ariya/phantomjs/archive/1.9.8.tar.gz"
    sha256 "3a321561677f678ca00137c47689e3379c7fe6b83f7597d2d5de187dd243f7be"
  end

  bottle do
    cellar :any
    sha1 "05b3572c88d11a7263d7b97b628793b7d45e3757" => :mavericks
    sha1 "a53f4d6c08beea6d3c2dbc709994ab33f1b4fe20" => :mountain_lion
    sha1 "24b6dbefe4186a2ebbaeef0d6cd217aecda1ff59" => :lion
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
