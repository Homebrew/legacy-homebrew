require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.1.tar.gz"
  sha1 "0ece88372e178985d3327bbb7a0c94947586b3f1"

  depends_on "libpng"
  depends_on "jpeg"

  def install
    # Following changes are necessary for compilation on OS X. These have been
    # reported to the author and can be removed once incorporated upstream.
    inreplace "libavutil/mem.c" do |s|
      s.gsub! "#include <malloc.h>", "#include <malloc/malloc.h>"
    end

    inreplace "Makefile" do |s|
      s.gsub! "#CONFIG_APPLE=y", "CONFIG_APPLE=y"
    end

    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
