class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.0/pngcrush-1.8.0.tar.gz"
  sha256 "6e7e95933f69615e563f14f62572820e229a6d586826418ef7016842d96b0d92"

  bottle do
    cellar :any_skip_relocation
    sha256 "148b59d68ff56fa492ecf0668a75cab7ebce6b44bb0d3dafde10c6294dd81fbd" => :el_capitan
    sha256 "e90f724a083bbb10dbe86651cd80e4e4ed79b574a78864b384646f182df1794e" => :yosemite
    sha256 "26f6ef3e7fc349408a7488b922cb60f0768ea28456082ff6413f398e5693a6de" => :mavericks
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default
    # since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
