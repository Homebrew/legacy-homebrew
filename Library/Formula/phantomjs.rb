require "formula"

# Upstream have said won't fix 1.9.x for Yosemite
# https://github.com/ariya/phantomjs/issues/10648
# Please remove this workaround with the next stable 2.0 release.

class MaximumMacOSRequirement < Requirement
  fatal true

  def initialize(tags)
    @version = MacOS::Version.from_symbol(tags.first)
    super
  end

  satisfy { MacOS.version <= @version }

  def message
    <<-EOS.undent
      OS X #{@version.pretty_name} or older is required for stable.
      Use `brew install --HEAD` for Yosemite.
    EOS
  end
end

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

    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    cellar :any
    sha1 "05b3572c88d11a7263d7b97b628793b7d45e3757" => :mavericks
    sha1 "a53f4d6c08beea6d3c2dbc709994ab33f1b4fe20" => :mountain_lion
    sha1 "24b6dbefe4186a2ebbaeef0d6cd217aecda1ff59" => :lion
  end

  head do
    url "https://github.com/ariya/phantomjs.git"

    depends_on "icu4c"
  end

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
