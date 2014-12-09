require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.1.tar.gz"
  sha1 "0ece88372e178985d3327bbb7a0c94947586b3f1"

  bottle do
    cellar :any
    sha1 "3ad0c2c2c23a9066e7e8db6ef93c90be7d0d8fe9" => :yosemite
    sha1 "d4f5563138bb800f9ec301a972ae9be74ba75672" => :mavericks
    sha1 "2edf42ccb895e3ff41f4c3c4a95c04d8543c5dd5" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    # Following changes are necessary for compilation on OS X. These have been
    # reported to the author and can be removed once incorporated upstream.
    inreplace "libavutil/mem.c" do |s|
      s.gsub! "#include <malloc.h>", "#include <malloc/malloc.h>"
    end

    bin.mkpath
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y"
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
