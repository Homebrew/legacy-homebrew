class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.91/pngcrush-1.7.91.tar.gz"
  sha256 "aed76bf3f2b96f34c764234ffb68bdaee9d6092b0738889575d6ea48ab07dc82"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d16dff9331f51153e3f09ffc24b8b59757716f45e04ac66987a4fec9acee3ac" => :el_capitan
    sha256 "884f9e7b02f0024379edd7902998efc0e5e2fabb28e5995fde7d7b63b0bb73bd" => :yosemite
    sha256 "91c172f162c8af493d7abeda8139054c15a4058529557c7307c8268bc99b1591" => :mavericks
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
