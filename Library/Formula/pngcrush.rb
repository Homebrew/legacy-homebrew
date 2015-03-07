class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.83/pngcrush-1.7.83.tar.gz"
  sha1 "70ae10e40ee86a79b855697389516e36d3ac7fda"

  bottle do
    cellar :any
    sha1 "60e7cfbb2c536a2af261226ba8553c632591e3e4" => :yosemite
    sha1 "4be7065b761cc8245fbb077f59d6b721faf14810" => :mavericks
    sha1 "e394e31b0526e84dc13ee40d8cd98442a90f9cfd" => :mountain_lion
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
