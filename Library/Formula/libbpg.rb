require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.tar.gz"
  sha1 "d40209384adf517c773a7a28cec0d4759051bf2c"

  bottle do
    cellar :any
    sha1 "5ce24008a63d1362c54f63765fefbf0fd8fcd2d0" => :yosemite
    sha1 "458ac4571970643dd81352d3a9591377c5004327" => :mavericks
    sha1 "8b906bd6b3f1537f6805e3bbd2df84dad93bcf43" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    # Following changes are necessary for compilation on OS X. These have been
    # reported to the author and can be removed once incorporated upstream.
    inreplace "libavutil/mem.c" do |s|
      s.gsub! "#include <malloc.h>", "#include <malloc/malloc.h>"
    end

    inreplace "Makefile" do |s|
      s.gsub! "--gc-sections", "-dead_strip"
      s.gsub! "LIBS:=-lrt -lm -lpthread", "LIBS:=-lm -lpthread"
    end

    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
