require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.2.tar.gz"
  sha1 "bec3a62198e23319b247d0efccb95ad4bf56bea5"

  bottle do
    cellar :any
    sha1 "50d98097dbcb3522c595727eecc00f2f114bcd2c" => :yosemite
    sha1 "40d4e971ba02d4c1568d7d3bcd70eade989d6c96" => :mavericks
    sha1 "eb59d1ed21a726da090e78406a78c15a1a06b915" => :mountain_lion
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
