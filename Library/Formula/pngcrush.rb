class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.86/pngcrush-1.7.86.tar.gz"
  sha256 "e24cd6355736622f94bfc67852da32a0e5eecdecff10293a16ed085573822f63"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd3962a63fb3c34be1a582c4e9e14765943360f3b53306ffa21ebc0756d24b18" => :el_capitan
    sha256 "e025ba7022707a514df43d808b4ec5f3e2c27a6d45df96669134ab3dbf7866b0" => :yosemite
    sha256 "c2023fac061f8910d86154cc4f685a631b374d911f984b0662003907fa772262" => :mavericks
    sha256 "5b735517f61cf6927a3838f5f4b18bf5ef4e11a59336cf0d4636f5c25f884d52" => :mountain_lion
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
