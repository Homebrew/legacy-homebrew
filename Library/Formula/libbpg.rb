require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.3.tar.gz"
  sha1 "02887f709458d6aca5f608ffc6416b6233465edf"

  bottle do
    cellar :any
    sha1 "b9c507c559617a5e916343aea3a943605626eefb" => :yosemite
    sha1 "256adcd800c53765e41b9bb302a0ff2f412a5e93" => :mavericks
    sha1 "4947077e367879313d4fed3f9e4c95988663a664" => :mountain_lion
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
