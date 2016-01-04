class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.92/pngcrush-1.7.92.tar.gz"
  sha256 "384e1e1a9cde0ece8750ea7663cabba6cec9756620e6f381043a32fcf42e1235"

  bottle do
    cellar :any_skip_relocation
    sha256 "4070a3fb3755efe1f53e182d5017ad787b46cb2333cbe9133d9382a9a7df4757" => :el_capitan
    sha256 "5b50d53c4b8f277da8444eee5d4a3e2a383bd6db7e5da751cc9acbc40a8c32c2" => :yosemite
    sha256 "8c44074e822d2db6d46b3cd019cd213d227793461b1413ea772e188ed5465614" => :mavericks
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
