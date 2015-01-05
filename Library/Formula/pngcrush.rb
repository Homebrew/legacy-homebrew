class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.82/pngcrush-1.7.82.tar.gz"
  sha1 "a9d7305908810a7da981611e7aea8830b3ff1f43"

  bottle do
    cellar :any
    sha1 "ddb569fe21bd966d5d3f51416bc824bd6772f9f3" => :yosemite
    sha1 "0c8cca15817311bacdc7b0fa4919b2dbfc3e1e62" => :mavericks
    sha1 "5774590804ab1bf665b1ec6f1a3b0abfaade3d05" => :mountain_lion
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default since 1.5.1)
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
